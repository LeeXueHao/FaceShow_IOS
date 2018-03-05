//
//  UpdateUserInfoRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpdateUserInfoRequest.h"

@implementation UpdateUserInfoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.sysUser.updateMyInfo";
        if (![UserManager sharedInstance].userModel.token) {
            self.method = @"app.sysUser.updateUserInfo";
            self.userId = [UserManager sharedInstance].userModel.userID;
        }
    }
    return self;
}
@end
