//
//  GetUserInfoRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetUserInfoRequest.h"

@implementation GetUserInfoRequestItem_imMember
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"memberID"}];
}

- (IMMember *)toIMMember {
    IMMember *member = [[IMMember alloc]init];
    member.memberID = self.memberID.integerValue;
    member.userID = self.userId.integerValue;
    member.name = self.memberName;
    member.avatar = self.avatar;
    return member;
}
@end

@implementation GetUserInfoRequestItem_imTokenInfo
@end

@implementation GetUserInfoRequestItem_Data
@end

@implementation GetUserInfoRequestItem
@end

@implementation GetUserInfoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.sysUser.userInfo";
    }
    return self;
}
@end
