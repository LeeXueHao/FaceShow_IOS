//
//  IMRequestManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMDatabaseManager.h"
#import "IMTextMessage.h"
#import "IMImageMessage.h"
#import "MqttServerRequest.h"

@interface IMRequestManager : NSObject
+ (IMRequestManager *)sharedInstance;

@property (nonatomic, assign, readonly) NSTimeInterval timeoffset;//记录server时间和本地时间偏差，在消息发送中用本地时间加上偏差的值模拟server时间时使用。

- (void)requestTopicsWithCompleteBlock:(void(^)(NSArray<IMTopic *> *topics,NSError *error))completeBlock;

- (void)requestTopicDetailWithTopicIds:(NSString *)topicIds
                         completeBlock:(void(^)(NSArray<IMTopic *> *topics,NSError *error))completeBlock;

- (void)requestTopicMsgsWithTopicID:(int64_t)topicID
                            startID:(int64_t)startID
                           asending:(BOOL)asending
                            dataNum:(NSInteger)num
                      completeBlock:(void(^)(NSArray<IMTopicMessage *> *msgs,NSError *error))completeBlock;

- (void)requestNewTopicWithMember:(IMMember *)member
                        fromGroup:(int64_t)groupID
                    completeBlock:(void(^)(IMTopic *topic,NSError *error))completeBlock;

- (void)requestSaveTextMsgWithMsg:(IMTextMessage *)msg
                    completeBlock:(void(^)(IMTopicMessage *msg,NSError *error))completeBlock;
- (void)requestSaveImageMsgWithMsg:(IMImageMessage *)msg
                     completeBlock:(void(^)(IMTopicMessage *msg,NSError *error))completeBlock;

- (void)requestTopicInfoWithTopicId:(NSString *)topicId
                      completeBlock:(void(^)(IMTopic *topic,NSError *error))completeBlock;

- (void)requestMqttServerWithCompleteBlock:(void(^)(MqttServerConfig *config,NSError *error))completeBlock;

@end
