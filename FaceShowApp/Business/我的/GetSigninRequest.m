//
//  GetSigninRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetSigninRequest.h"

@implementation GetSigninRequestItem_data
@end

@implementation GetSigninRequestItem
@end

@implementation GetSigninRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.getSignIn";
    }
    return self;
}
@end
