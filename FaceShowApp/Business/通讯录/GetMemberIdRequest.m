//
//  GetMemberIdRequest.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetMemberIdRequest.h"
#import "IMConfig.h"
#import "IMManager.h"
#import "ContactMemberContactsRequest.h"
@implementation GetMemberIdRequest_personalConfig

@end

@implementation GetMemberIdRequest_topic
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"topicId"}];
}
-(ContactMemberContactsRequestItem_Data_Gcontacts_Groups *)toContactsGroup{
    ContactMemberContactsRequestItem_Data_Gcontacts_Groups *group = [[ContactMemberContactsRequestItem_Data_Gcontacts_Groups alloc]init];
    group.groupId = self.topicId;
    group.groupName = self.topicName;
    return group;
}
@end

@implementation GetMemberIdRequestItem_data

@end

@implementation GetMemberIdRequestItem

@end

@interface GetMemberIdRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@end

@implementation GetMemberIdRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"login.getMemberTopic";
        self.bizSource = kBizSourse;
        self.imToken = [IMManager sharedInstance].token;
    }
    return self;
}
@end
