//
//  IMHistoryMessageFetcher.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMHistoryMessageFetcher.h"
#import "IMDatabaseManager.h"
#import "IMRequestManager.h"

NSString * const kIMHistoryMessageDidUpdateNotification = @"kIMHistoryMessageDidUpdateNotification";
NSString * const kIMHistoryMessageTopicKey = @"kIMHistoryMessageTopicKey";
NSString * const kIMHistoryMessageKey = @"kIMHistoryMessageKey";
NSString * const kIMHistoryMessageHasMoreKey = @"kIMHistoryMessageHasMoreKey";
NSString * const kIMHistoryMessageErrorKey = @"kIMHistoryMessageErrorKey";

@interface IMHistoryMessageFetcher()
@property (nonatomic, strong) NSMutableArray<IMHistoryFetchRecord *> *recordArray;
@property (nonatomic, assign) BOOL isMsgFetching;
@end

@implementation IMHistoryMessageFetcher
+ (IMHistoryMessageFetcher *)sharedInstance {
    static IMHistoryMessageFetcher *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMHistoryMessageFetcher alloc] init];
        manager.recordArray = [NSMutableArray array];
        manager.isMsgFetching = NO;
    });
    return manager;
}

- (void)addRecord:(IMHistoryFetchRecord *)record {
    for (IMHistoryFetchRecord *item in self.recordArray) {
        if (item.topic.topicID == record.topic.topicID) {
            return;
        }
    }
    [self.recordArray addObject:record];
    [self checkAndUpdate];
}

- (void)checkAndUpdate{
    if (!self.isMsgFetching && self.recordArray.count>0) {
        self.isMsgFetching = YES;
        IMHistoryFetchRecord *record = [self.recordArray firstObject];
        if (!record.beforeMsg) {
            IMTopicMessage *msg = [[IMTopicMessage alloc]init];
            msg.messageID = INT64_MAX;
            msg.index = INT64_MAX;
            record.beforeMsg = msg;
        }
        if (record.beforeMsg.messageID == 0) {
            record.beforeMsg.messageID = INT64_MAX;
        }
        [[IMDatabaseManager sharedInstance]findMessagesInTopic:record.topic.topicID count:record.count beforeIndex:record.beforeMsg.index completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
            if (array.count > 0) {
                [self postNotificationWithMsgs:array topicID:record.topic.topicID hasMore:YES];
                [self fetchNext];
            }else {
                // 有真实messageID时，返回的消息会包含当前的message，所以需要多取一个
                NSInteger offset = record.beforeMsg.messageID!=INT64_MAX;
                [[IMRequestManager sharedInstance]requestTopicMsgsWithTopicID:record.topic.topicID startID:record.beforeMsg.messageID asending:NO dataNum:record.count+1+offset completeBlock:^(NSArray<IMTopicMessage *> *msgs, NSError *error) {
                    if (error) {
                        [self postNotificationWithMsgs:nil topicID:record.topic.topicID hasMore:NO];
                        [self fetchNext];
                        return;
                    }
                    BOOL more = (msgs.count-offset)>record.count;
                    NSMutableArray *array = [NSMutableArray arrayWithArray:msgs];
                    if (offset > 0) {
                        [array removeObjectAtIndex:0];
                    }
                    if (more) {
                        [array removeLastObject];
                    }
                    [[IMDatabaseManager sharedInstance]saveHistoryMessages:array completeBlock:^(NSArray<IMTopicMessage *> *savedMsgs) {
                        [self postNotificationWithMsgs:savedMsgs topicID:record.topic.topicID hasMore:more];
                        [self fetchNext];
                    }];
                }];
            }
        }];
    }
}

- (void)postNotificationWithMsgs:(NSArray *)msgs topicID:(int64_t)topicID hasMore:(BOOL)hasMore {
    NSDictionary *info = @{kIMHistoryMessageTopicKey:@(topicID),
                           kIMHistoryMessageKey:msgs,
                           kIMHistoryMessageHasMoreKey:@(hasMore)};
    [[NSNotificationCenter defaultCenter]postNotificationName:kIMHistoryMessageDidUpdateNotification object:nil userInfo:info];
}

- (void)postNotificationWithError:(NSError *)error topicID:(int64_t)topicID {
    NSDictionary *info = @{kIMHistoryMessageTopicKey:@(topicID),
                           kIMHistoryMessageErrorKey:error};
    [[NSNotificationCenter defaultCenter]postNotificationName:kIMHistoryMessageDidUpdateNotification object:nil userInfo:info];
}

- (void)fetchNext {
    [self.recordArray removeObjectAtIndex:0];
    self.isMsgFetching = NO;
    [self checkAndUpdate];
}

@end
