//
//  IMOfflineMsgUpdateService.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMOfflineMsgUpdateService : NSObject
- (instancetype)initWithTopicID:(int64_t)topicID startID:(int64_t)startID;

- (void)startWithCompleteBlock:(void(^)(NSError *error))completeBlock;

@end
