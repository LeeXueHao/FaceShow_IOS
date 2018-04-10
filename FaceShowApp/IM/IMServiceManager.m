//
//  IMServiceManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMServiceManager.h"
#import "IMRequestManager.h"
#import "IMTopicUpdateService.h"
#import "IMDatabaseManager.h"
#import "IMConnectionManager.h"
#import "IMConfig.h"
#import "IMOfflineMsgUpdateService.h"
#import "IMOfflineMsgUpdateServiceManager.h"
#import "IMManager.h"
#import "IMHistoryMessageFetcher.h"

@interface IMServiceManager()
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, assign) NetworkStatus networkStatus;
@property (nonatomic, strong) IMTopicUpdateService *topicUpdateService;
@property (nonatomic, strong) IMOfflineMsgUpdateServiceManager *offlineServiceManager;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, strong) NSTimer *reconnectTimer;
@end

@implementation IMServiceManager
+ (IMServiceManager *)sharedInstance {
    static IMServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMServiceManager alloc] init];
        manager.networkStatus = NotReachable;
        manager.topicUpdateService = [[IMTopicUpdateService alloc]init];
        manager.offlineServiceManager = [[IMOfflineMsgUpdateServiceManager alloc]init];
        manager.running = NO;
    });
    return manager;
}

- (void)start {
    if (self.running) {
        return;
    }
    self.running = YES;
    [self listenNetWorkingStatus];
    if (self.networkStatus != NotReachable) {
        [self startServicesForNetworkReachable];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionClosed:) name:kIMConnectionDidCloseNotification object:nil];
}

- (void)stop {
    if (!self.running) {
        return;
    }
    self.running = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kIMConnectionDidCloseNotification object:nil];
    [[IMConnectionManager sharedInstance]disconnect];
}

-(void)listenNetWorkingStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    // 设置网络检测的站点
    NSString *remoteHostName = @"www.apple.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    self.networkStatus = [self.hostReachability currentReachabilityStatus];
    [self.hostReachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (self.networkStatus == NotReachable &&
        netStatus != NotReachable) {
        [self startServicesForNetworkReachable];
    }else if (self.networkStatus != NotReachable &&
              netStatus != NotReachable &&
              self.networkStatus != netStatus) {
        NSArray *topics = [[IMDatabaseManager sharedInstance]findAllTopics];
        [self connectAndSubscribeWithTopics:topics];
    }
    self.networkStatus = netStatus;
}

- (void)connectAndSubscribeWithTopics:(NSArray *)topics {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestMqttServerWithCompleteBlock:^(MqttServerConfig *config, NSError *error) {
        STRONG_SELF
        if (!config) {
            return;
        }
        [[IMConnectionManager sharedInstance]connectWithHost:config.server port:config.port username:kUsername password:kPassword];
        [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForCurrentMember]];
        for (IMTopic *topic in topics) {
            [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:topic.topicID]];
        }
    }];
}

- (void)startServicesForNetworkReachable {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestTopicsWithCompleteBlock:^(NSArray<IMTopic *> *topics, NSError *error) {
        STRONG_SELF
        if (error) {
            return;
        }
        [self clearDeletedTopicsWithTopics:topics];
        [self updateTopics:topics];
        [self connectAndSubscribeWithTopics:topics];
    }];
}

- (void)clearDeletedTopicsWithTopics:(NSArray *)topics {
    NSArray *localTopics = [[IMDatabaseManager sharedInstance]findAllTopics];
    for (IMTopic *localItem in localTopics) {
        if ([[IMDatabaseManager sharedInstance]isTempTopicID:localItem.topicID]) {
            continue;
        }
        BOOL deleted = YES;
        for (IMTopic *item in topics) {
            if (item.topicID == localItem.topicID) {
                deleted = NO;
                break;
            }
        }
        if (deleted) {
            [[IMConnectionManager sharedInstance]unsubscribeTopic:[IMConfig topicForTopicID:localItem.topicID]];
            [[IMDatabaseManager sharedInstance]clearTopic:localItem];
        }
    }
}

- (void)updateTopics:(NSArray *)topics {
    for (IMTopic *topic in topics) {
        // update topics
        IMTopic *dbTopic = [[IMDatabaseManager sharedInstance]findTopicWithID:topic.topicID];
        if (topic.topicChange != dbTopic.topicChange) {
            topic.topicChange = dbTopic.topicChange;
            [[IMDatabaseManager sharedInstance]saveTopic:topic];
            [self.topicUpdateService addTopic:topic];
        }
        // update offline msgs
        IMTopicMessage *lastMsg = [[IMDatabaseManager sharedInstance]findLastSuccessfulMessageInTopic:topic.topicID];
        int64_t lastID = 0;
        if (lastMsg) {
            lastID = lastMsg.messageID;
        }else if (dbTopic) {
            lastID = dbTopic.latestMsgId;
        }
        if (lastID > 0 && topic.latestMsgId > lastID) {
            IMTopicOfflineMsgFetchRecord *record = [[IMTopicOfflineMsgFetchRecord alloc]init];
            record.topicID = topic.topicID;
            record.startID = lastID;
            [[IMDatabaseManager sharedInstance]saveOfflineMsgFetchRecord:record];
        }
        NSArray *offlineRecords = [[IMDatabaseManager sharedInstance]findAllOfflineMsgFetchRecordsWithTopicID:topic.topicID];
        for (IMTopicOfflineMsgFetchRecord *item in offlineRecords) {
            IMOfflineMsgUpdateService *offlineService = [[IMOfflineMsgUpdateService alloc]initWithTopicID:item.topicID startID:item.startID];
            [self.offlineServiceManager addService:offlineService];
        }
        // history msgs
        if (offlineRecords.count == 0 && !dbTopic.latestMessage) {
            IMHistoryFetchRecord *record = [[IMHistoryFetchRecord alloc]init];
            record.topic = topic;
            record.count = 15;
            [[IMHistoryMessageFetcher sharedInstance]addRecord:record];
        }
    }
}

#pragma mark - 连接断开处理
- (void)connectionClosed:(NSNotification *)note {
    if (self.running && self.networkStatus!=NotReachable) {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reconnectTimerAction) userInfo:nil repeats:NO];
    }
}

- (void)reconnectTimerAction {
    if (self.running && self.networkStatus!=NotReachable && ![IMConnectionManager sharedInstance].isConnectionOpen) {
        [self startServicesForNetworkReachable];
    }
}

@end
