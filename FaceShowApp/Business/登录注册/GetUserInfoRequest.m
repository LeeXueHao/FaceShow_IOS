//
//  GetUserInfoRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetUserInfoRequest.h"
@implementation GetUserInfoRequestItem_Data_Aui
@end
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

@implementation GetUserInfoRequestItem
@end

@implementation GetUserInfoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.sysUser.userInfo";
#ifdef HuBeiApp
        self.urlHead = [ConfigManager sharedInstance].server1_1;
#else
#endif
    }
    return self;
}
@end
