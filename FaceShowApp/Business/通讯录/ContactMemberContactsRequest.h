//
//  ContactMemberContactsRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "IMMember.h"

@interface ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo_MemberInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *memberInfoId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *memberType;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *memberName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *state;

@end

@protocol ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo<NSObject>
@end
@interface ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *contactsInfoId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *memberId;
@property (nonatomic, strong) NSString<Optional> *contactId;
@property (nonatomic, strong) NSString<Optional> *contactType;
@property (nonatomic, strong) ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo_MemberInfo<Optional> *memberInfo;

- (IMMember *)toIMMember;
@end


@protocol ContactMemberContactsRequestItem_Data_Gcontacts_Personals<NSObject>
@end
@interface ContactMemberContactsRequestItem_Data_Gcontacts_Personals : JSONModel
@property (nonatomic, strong) NSArray<ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo, Optional> *contactsInfo;
@end


@protocol ContactMemberContactsRequestItem_Data_Gcontacts_Groups<NSObject>
@end
@interface ContactMemberContactsRequestItem_Data_Gcontacts_Groups : JSONModel
@property (nonatomic, strong) NSArray<ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo, Optional> *contacts;
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *groupName;
@end


@protocol ContactMemberContactsRequestItem_Data_Gcontacts<NSObject>
@end
@interface ContactMemberContactsRequestItem_Data_Gcontacts : JSONModel
@property (nonatomic, strong) NSArray<ContactMemberContactsRequestItem_Data_Gcontacts_Groups, Optional> *groups;
@property (nonatomic, strong) NSArray<ContactMemberContactsRequestItem_Data_Gcontacts_Personals, Optional> *personals;
@end


@protocol GetUserInfoRequestItem_Data<NSObject>
@end
@interface ContactMemberContactsRequestItem_Data : JSONModel
@property (nonatomic, strong) ContactMemberContactsRequestItem_Data_Gcontacts<Optional> *contacts;
@property (nonatomic, strong) NSString<Optional> *imEvent;
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *topicChange;
@property (nonatomic, strong) NSString<Optional> *topic;
@property (nonatomic, strong) NSString<Optional> *topicMsg;
@property (nonatomic, strong) NSString<Optional> *chatroom;
@property (nonatomic, strong) NSString<Optional> *members;
@end

@interface ContactMemberContactsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ContactMemberContactsRequestItem_Data<Optional> *data;
@property (nonatomic, strong) NSString<Optional> *currentUser;
@end

@interface ContactMemberContactsRequest : YXGetRequest
@property (nonatomic, strong) NSString *reqId;
@end
