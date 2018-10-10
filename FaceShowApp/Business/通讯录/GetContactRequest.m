//
//  ClazsMemberListRequest.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetContactRequest.h"
#import "IMManager.h"
#import "IMConfig.h"


@implementation GetContactRequestItem_Data_Gcontacts_ContactsInfo_MemberInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"memberInfoId"}];
}
@end

@implementation GetContactRequestItem_Data_Gcontacts_ContactsInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"contactsInfoId"}];
}

- (IMMember *)toIMMember {
    IMMember *member = [[IMMember alloc]init];
    member.memberID = self.memberInfo.memberInfoId.longLongValue;
    member.userID = self.memberInfo.userId.longLongValue;
    member.avatar = self.memberInfo.avatar;
    member.name = self.memberInfo.memberName;
    return member;
}
@end

@implementation GetContactRequestItem_Data_Gcontacts_Personals
@end

@implementation GetContactRequestItem_Data_Gcontacts_Groups
@end

@implementation GetContactRequestItem_Data_Gcontacts
@end

@implementation GetContactRequestItem_Data
@end

@implementation GetContactRequestItem
@end

@interface GetContactRequest()
@property (nonatomic, strong) NSString *reqId;
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@end

@implementation GetContactRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"contact.getContact";
        self.reqId = [IMConfig generateUniqueID];
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance] token];
    }
    return self;
}
@end
