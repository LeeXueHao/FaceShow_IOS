//
//  ContactMemberContactsRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactMemberContactsRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo_MemberInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"memberInfoId"}];
}
@end

@implementation ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo
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

@implementation ContactMemberContactsRequestItem_Data_Gcontacts_Personals
@end

@implementation ContactMemberContactsRequestItem_Data_Gcontacts_Groups
@end

@implementation ContactMemberContactsRequestItem_Data_Gcontacts
@end

@implementation ContactMemberContactsRequestItem_Data
@end

@implementation ContactMemberContactsRequestItem
@end

@interface ContactMemberContactsRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@end

@implementation ContactMemberContactsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"contact.memberContacts";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
    }
    return self;
}
@end
