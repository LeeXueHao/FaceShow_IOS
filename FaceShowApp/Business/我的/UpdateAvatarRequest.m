//
//  UpdateAvatarRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpdateAvatarRequest.h"

@implementation UpdateAvatarRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"sysUser.updateAvatar";
    }
    return self;
}
@end
