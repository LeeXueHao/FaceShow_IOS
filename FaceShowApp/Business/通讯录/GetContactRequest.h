//
//  ClazsMemberListRequest.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "IMMember.h"

@interface GetContactRequestItem_Data_Gcontacts_ContactsInfo_MemberInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *memberInfoId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *memberType;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *memberName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *state;

@end

@protocol GetContactRequestItem_Data_Gcontacts_ContactsInfo<NSObject>
@end
@interface GetContactRequestItem_Data_Gcontacts_ContactsInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *contactsInfoId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *memberId;
@property (nonatomic, strong) NSString<Optional> *contactId;
@property (nonatomic, strong) NSString<Optional> *contactType;
@property (nonatomic, strong) GetContactRequestItem_Data_Gcontacts_ContactsInfo_MemberInfo<Optional> *memberInfo;

- (IMMember *)toIMMember;
@end


@protocol GetContactRequestItem_Data_Gcontacts_Personals<NSObject>
@end
@interface GetContactRequestItem_Data_Gcontacts_Personals : JSONModel
@property (nonatomic, strong) NSArray<GetContactRequestItem_Data_Gcontacts_ContactsInfo, Optional> *contactsInfo;
@end


@protocol GetContactRequestItem_Data_Gcontacts_Groups<NSObject>
@end
@interface GetContactRequestItem_Data_Gcontacts_Groups : JSONModel
@property (nonatomic, strong) NSArray<GetContactRequestItem_Data_Gcontacts_ContactsInfo, Optional> *contacts;
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *groupName;
@end


@protocol GetContactRequestItem_Data_Gcontacts<NSObject>
@end
@interface GetContactRequestItem_Data_Gcontacts : JSONModel
@property (nonatomic, strong) NSArray<GetContactRequestItem_Data_Gcontacts_Groups, Optional> *groups;
@property (nonatomic, strong) NSArray<GetContactRequestItem_Data_Gcontacts_Personals, Optional> *personals;
@end


@protocol GetUserInfoRequestItem_Data<NSObject>
@end
@interface GetContactRequestItem_Data : JSONModel
@property (nonatomic, strong) GetContactRequestItem_Data_Gcontacts<Optional> *contacts;
@property (nonatomic, strong) NSString<Optional> *imEvent;
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *topicChange;
@property (nonatomic, strong) NSString<Optional> *topic;
@property (nonatomic, strong) NSString<Optional> *topicMsg;
@property (nonatomic, strong) NSString<Optional> *chatroom;
@property (nonatomic, strong) NSString<Optional> *members;
@end

@interface GetContactRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetContactRequestItem_Data<Optional> *data;
@property (nonatomic, strong) NSString<Optional> *currentUser;
@end


@interface GetContactRequest : YXGetRequest
@property (nonatomic, strong) NSString *topicId;
@end
