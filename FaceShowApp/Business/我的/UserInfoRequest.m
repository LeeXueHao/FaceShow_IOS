//
//  UserInfoRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoRequest.h"
@implementation UserInfoRequestItem_Data

@end
@implementation UserInfoRequestItem

@end
@implementation UserInfoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://orz.yanxiu.com/pxt/platform/data.api";
        self.method = @"sysUser.userInfo";
        self.userId = @"10145096";
    }
    return self;
}
@end
