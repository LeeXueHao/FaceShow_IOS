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
    });
    return manager;
}

- (void)start {
    [self listenNetWorkingStatus];
    if (self.networkStatus != NotReachable) {
        [self startServicesForNetworkReachable];
    }
}

- (void)stop {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[IMConnectionManager sharedInstance]disconnect];
    [self.topicUpdateService removeAllTopics];
    [self.offlineMsgServices removeAllObjects];
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
    if (self.networkStatus == NotReachable && netStatus != NotReachable) {
        [self startServicesForNetworkReachable];
    }
    self.networkStatus = netStatus;
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
        
        [[IMConnectionManager sharedInstance]connectWithHost:kHost port:kPort username:kUsername password:kPassword];
        [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForCurrentMember]];
        for (IMTopic *topic in topics) {
            [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:topic.topicID]];
        }
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
        if (dbTopic.latestMessage && topic.latestMsgId > dbTopic.latestMessage.messageID) {
            IMOfflineMsgUpdateService *offlineService = [[IMOfflineMsgUpdateService alloc]initWithTopicID:topic.topicID startID:dbTopic.latestMessage.messageID];
            [self.offlineMsgServices addObject:offlineService];
            [offlineService start];
        }
    }
}

@end
