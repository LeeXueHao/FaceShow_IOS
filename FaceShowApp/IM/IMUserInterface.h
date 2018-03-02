//
//  IMUserInterface.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTopicMessage.h"
#import "IMTopic.h"

@interface IMUserInterface : NSObject

+ (void)sendTextMessageWithText:(NSString *)text topicID:(int64_t)topicID;
+ (void)sendTextMessageWithText:(NSString *)text topicID:(int64_t)topicID uniqueID:(NSString *)uniqueID;
+ (void)sendTextMessageWithText:(NSString *)text toMember:(IMMember *)member;//用于新建会话尚无topicID的情况

+ (NSArray<IMTopic *> *)findAllTopics;
+ (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;
+ (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                beforeIndex:(int64_t)index
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;
+ (void)clearDirtyMessages;
+ (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID;

// Notifications
UIKIT_EXTERN NSNotificationName const kIMMessageDidUpdateNotification;

UIKIT_EXTERN NSNotificationName const kIMTopicDidUpdateNotification;

UIKIT_EXTERN NSNotificationName const kIMUnreadMessageCountDidUpdateNotification;
UIKIT_EXTERN NSString * const kIMUnreadMessageCountTopicKey;
UIKIT_EXTERN NSString * const kIMUnreadMessageCountKey;

@end
