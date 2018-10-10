//
//  GetUserInfoDetailRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserInfoDetailRequest.h"

@implementation GetUserInfoDetailRequestItem_aui
@end

@implementation GetUserInfoDetailRequestItem_Data
- (NSString *)sexString {
    return self.sex.integerValue ? @"男" : @"女";
}
- (NSString *)stageName {
    if ([_stageName isEqualToString:@"通识"]) {
        return @"跨学段";
    }
    return _stageName;
}
@end

@implementation GetUserInfoDetailRequestItem
@end

@implementation GetUserInfoDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].server1_1;
        self.method = @"sysUser.userInfo";
    }
    return self;
}
@end
