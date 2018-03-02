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

@interface IMRequestManager : NSObject
+ (IMRequestManager *)sharedInstance;

- (void)requestTopicsWithCompleteBlock:(void(^)(NSArray<IMTopic *> *topics,NSError *error))completeBlock;

- (void)requestTopicDetailWithTopicIds:(NSString *)topicIds
                         completeBlock:(void(^)(NSArray<IMTopic *> *topics,NSError *error))completeBlock;

- (void)requestTopicMsgsWithTopicID:(int64_t)topicID
                            startID:(int64_t)startID
                           asending:(BOOL)asending
                      completeBlock:(void(^)(NSArray<IMTopicMessage *> *msgs,NSError *error))completeBlock;

- (void)requestNewTopicWithMember:(IMMember *)member
                    completeBlock:(void(^)(IMTopic *topic,NSError *error))completeBlock;

- (void)requestSaveTextMsgWithMsg:(IMTextMessage *)msg
                    completeBlock:(void(^)(IMTopicMessage *msg,NSError *error))completeBlock;

@end
