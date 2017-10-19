//
//  GetVerifyCodeRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetVerifyCodeRequest.h"

@implementation GetVerifyCodeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"sysUser.app.getCode";
    }
    return self;
}
@end
