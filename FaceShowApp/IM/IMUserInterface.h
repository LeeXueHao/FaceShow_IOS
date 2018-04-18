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
+ (void)sendTextMessageWithText:(NSString *)text toMember:(IMMember *)member fromGroup:(int64_t)groupID;//用于新建会话尚无topicID的情况

+ (void)sendImageMessageWithImage:(UIImage *)image topicID:(int64_t)topicID;
+ (void)sendImageMessageWithImage:(UIImage *)image topicID:(int64_t)topicID uniqueID:(NSString *)uniqueID;
+ (void)sendImageMessageWithImage:(UIImage *)image toMember:(IMMember *)member fromGroup:(int64_t)groupID;

+ (NSArray<IMTopic *> *)findAllTopics;
+ (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock;
+ (void)findMessagesInTopic:(IMTopic *)topic
                      count:(NSUInteger)count
                  beforeMsg:(IMTopicMessage *)msg;

+ (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID;

/**
 从通讯录选择某一个联系人/群聊界面点击某个联系人的头像进入聊天界面的时候调用
 
 @param member 联系人信息
 @return 聊天信息
 */
+ (IMTopic *)findTopicWithMember:(IMMember *)member;

/**
 记录server时间和本地时间偏差，在消息发送中用本地时间加上偏差的值模拟server时间时使用。

 @return 时间差
 */
+ (NSTimeInterval)obtainTimeoffset;

/**
 当前的member是否在某个topic里面
 @return 传入的member在传入的topic中返回YES,否则返回NO
 */
+ (BOOL)topic:(IMTopic *)topic isWithMember:(IMMember *)member;

/**
 判断两个topic是否为同一个
 @return 是同一个返回YES,否则返回NO
 */
+ (BOOL)isSameTopicWithOneTopic:(IMTopic *)topic anotherTopic:(IMTopic *)anotherTopic;


/**
 获取话题基本信息，仅用于更新名称，成员信息
 @param topicID topicID
 */
+ (void)updateTopicInfoWithTopicID:(int64_t)topicID;

// Notifications
UIKIT_EXTERN NSNotificationName const kIMMessageDidUpdateNotification;

UIKIT_EXTERN NSNotificationName const kIMTopicDidUpdateNotification;
UIKIT_EXTERN NSNotificationName const kIMTopicInfoUpdateNotification;//更新话题的名称，成员信息
UIKIT_EXTERN NSNotificationName const kIMTopicDidRemoveNotification;

UIKIT_EXTERN NSNotificationName const kIMUnreadMessageCountDidUpdateNotification;
UIKIT_EXTERN NSString * const kIMUnreadMessageCountTopicKey;
UIKIT_EXTERN NSString * const kIMUnreadMessageCountKey;

UIKIT_EXTERN NSNotificationName const kIMImageUploadDidUpdateNotification; // 图片上传进度更新
UIKIT_EXTERN NSString * const kIMImageUploadTopicKey; // topicID
UIKIT_EXTERN NSString * const kIMImageUploadMessageKey; // uniqueID
UIKIT_EXTERN NSString * const kIMImageUploadProgressKey; // percent e.g. 0.25

//历史消息
UIKIT_EXTERN NSNotificationName const kIMHistoryMessageDidUpdateNotification;
UIKIT_EXTERN NSString * const kIMHistoryMessageTopicKey; // topicID
UIKIT_EXTERN NSString * const kIMHistoryMessageKey; // message array
UIKIT_EXTERN NSString * const kIMHistoryMessageHasMoreKey; // has more
UIKIT_EXTERN NSString * const kIMHistoryMessageErrorKey; // has more

@end
