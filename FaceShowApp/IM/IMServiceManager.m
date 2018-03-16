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

@interface IMServiceManager()
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, assign) NetworkStatus networkStatus;
@property (nonatomic, strong) IMTopicUpdateService *topicUpdateService;
@property (nonatomic, strong) NSMutableArray<IMOfflineMsgUpdateService *> *offlineMsgServices;
@property (nonatomic, assign) BOOL running;
@end

@implementation IMServiceManager
+ (IMServiceManager *)sharedInstance {
    static IMServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMServiceManager alloc] init];
        manager.networkStatus = NotReachable;
        manager.topicUpdateService = [[IMTopicUpdateService alloc]init];
        manager.offlineMsgServices = [NSMutableArray array];
        manager.running = NO;
    });
    return manager;
}

- (void)start {
    if (self.running) {
        return;
    }
    [self listenNetWorkingStatus];
    if (self.networkStatus != NotReachable) {
        [self startServicesForNetworkReachable];
    }
    self.running = YES;
}

- (void)stop {
    if (!self.running) {
        return;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[IMConnectionManager sharedInstance]disconnect];
    [self.topicUpdateService removeAllTopics];
    [self.offlineMsgServices removeAllObjects];
    self.running = NO;
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
    [[IMConnectionManager sharedInstance]connectWithHost:kHost port:kPort username:kUsername password:kPassword];
    [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForCurrentMember]];
    for (IMTopic *topic in topics) {
        [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:topic.topicID]];
    }
}

- (void)startServicesForNetworkReachable {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestTopicsWithCompleteBlock:^(NSArray<IMTopic *> *topics, NSError *error) {
        STRONG_SELF
        if (error) {
            return;
        }
        [self updateTopics:topics];
        for (IMTopic *topic in topics) {
            [[IMDatabaseManager sharedInstance]saveTopic:topic];
        }
        [self connectAndSubscribeWithTopics:topics];
    }];
}

- (void)updateTopics:(NSArray *)topics {
    for (IMTopic *topic in topics) {
        // update topics
        IMTopic *dbTopic = [[IMDatabaseManager sharedInstance]findTopicWithID:topic.topicID];
        if (topic.topicChange != dbTopic.topicChange) {
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
            IMOfflineMsgUpdateService *offlineService = [[IMOfflineMsgUpdateService alloc]initWithTopicID:topic.topicID startID:lastID];
            [self.offlineMsgServices addObject:offlineService];
            [offlineService start];
        }
    }
}

@end
