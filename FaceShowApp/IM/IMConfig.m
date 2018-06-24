//
//  IMConfig.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/2/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMConfig.h"
#import "IMManager.h"

#ifdef DEBUG
NSString * const kIMRequestUrlHead = @"http://hbyxb.ymd.yanxiu.com/im/platform/data.api";
NSString * const kUsername = @"admin";
NSString * const kPassword = @"public";
#else
NSString * const kIMRequestUrlHead = @"http://im.yanxiu.com/im/platform/data.api";
NSString * const kUsername = @"yxwork";
NSString * const kPassword = @"79A6g3pHb4tz2Bs8";
#endif

NSString * const kBizSourse = @"22";

@implementation IMConfig

+ (NSString *)topicForCurrentMember {
    return [NSString stringWithFormat:@"im/v1.0/member/%@",@([IMManager sharedInstance].currentMember.memberID)];
}

+ (NSString *)topicForTopicID:(int64_t)topicID {
    return [NSString stringWithFormat:@"im/v1.0/topic/%@",@(topicID)];
}

+ (NSString *)generateUniqueID {
    return [[NSString stringWithFormat:@"%@:%@",[IMManager sharedInstance].token,[[NSUUID UUID]UUIDString]]md5];
}

+ (NSString *)sceneInfoString {
    return [NSString stringWithFormat:@"{\"scene\":\"clazs\", \"sceneId\":\"%@\"}",[IMManager sharedInstance].sceneID];
}

@end
