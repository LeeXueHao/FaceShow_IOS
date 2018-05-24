//
//  IMDatabaseManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMember.h"
#import "IMTopicMessage.h"
#import "IMTopic.h"
#import "IMTopicOfflineMsgFetchRecord.h"

@interface IMDatabaseManager : NSObject
+ (IMDatabaseManager *)sharedInstance;

- (void)saveMember:(IMMember *)member;
- (void)saveMessage:(IMTopicMessage *)message;
- (void)saveMessages:(NSArray<IMTopicMessage *> *)messages;
- (void)saveHistoryMessages:(NSArray<IMTopicMessage *> *)messages
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *savedMsgs))completeBlock;
- (void)saveTopic:(IMTopic *)topic;
- (void)updateTopicInfo:(IMTopic *)topic;//用于更新话题名称，成员信息
- (void)clearTopic:(IMTopic *)topic;

- (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID;
- (int64_t)generateTempTopicID;
- (BOOL)isTempTopicID:(int64_t)topicID;

- (void)markAllUncompleteMessagesFailed;

- (NSArray<IMTopic *> *)findAllTopics;
- (IMTopic *)findTopicWithID:(int64_t)topicID;

- (IMTopicMessage *)findMessageWithUniqueID:(NSString *)uniqueID;
- (IMTopicMessage *)findLastSuccessfulMessageInTopic:(int64_t)topicID;
- (IMTopicMessage *)findFirstSuccessfulMessageInTopic:(int64_t)topicID;

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                beforeIndex:(int64_t)index
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;

- (IMTopic *)findTopicWithMember:(IMMember *)member;
- (NSArray<IMTopicMessage *> *)findAllFailedMessages;

#pragma mark - 离线消息抓取相关
- (NSArray<IMTopicOfflineMsgFetchRecord *> *)findAllOfflineMsgFetchRecordsWithTopicID:(int64_t)topicID;
- (void)saveOfflineMsgFetchRecord:(IMTopicOfflineMsgFetchRecord *)record;
- (void)updateOfflineMsgFetchRecordStartIDInTopic:(int64_t)topicID from:(int64_t)from to:(int64_t)to;
- (void)removeOfflineMsgFetchRecordInTopic:(int64_t)topicID withStartID:(int64_t)startID;
@end
