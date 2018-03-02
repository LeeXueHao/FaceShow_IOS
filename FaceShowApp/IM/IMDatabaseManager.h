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

@interface IMDatabaseManager : NSObject
+ (IMDatabaseManager *)sharedInstance;

- (void)saveMember:(IMMember *)member;
- (void)saveMessage:(IMTopicMessage *)message;
- (void)saveTopic:(IMTopic *)topic;

- (void)clearDirtyMessages;// 清除没有所属topic的所有message
- (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID;

- (NSArray<IMTopic *> *)findAllTopics;
- (IMTopic *)findTopicWithID:(int64_t)topicID;

- (IMTopicMessage *)findMessageWithUniqueID:(NSString *)uniqueID;

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                beforeIndex:(int64_t)index
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;

/**
  从通讯录选择某一个联系人进入聊天界面的时候调用

 @param member 联系人信息
 @return 聊天信息
 */
- (IMTopic *)findTopicWithMember:(IMMember *)member;
@end
