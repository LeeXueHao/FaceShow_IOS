//
//  ResetPasswordRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResetPasswordRequest.h"

@implementation ResetPasswordRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"sysUser.app.initPassword";
    }
    return self;
}
@end
