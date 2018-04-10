//
//  IMConfig.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/2/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kIMRequestUrlHead;
extern NSString * const kUsername;
extern NSString * const kPassword;

extern NSString * const kBizSourse;

@interface IMConfig : NSObject

+ (NSString *)topicForCurrentMember;
+ (NSString *)topicForTopicID:(int64_t)topicID;

+ (NSString *)generateUniqueID;

+ (NSString *)sceneInfoString;

@end
