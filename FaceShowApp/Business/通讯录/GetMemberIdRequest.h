//
//  GetMemberIdRequest.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@class ContactMemberContactsRequestItem_Data_Gcontacts_Groups;
//http://wiki.yanxiu.com/pages/viewpage.action?pageId=12326677#id-用户、登录接口-1.3获取用户在im的id

@interface GetMemberIdRequest_personalConfig : JSONModel
@property (nonatomic, strong) NSString<Optional> *quite;
@end

@interface GetMemberIdRequest_topic : JSONModel
@property (nonatomic, strong) NSString<Optional> *latestMsgId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *latestMsgTime;
@property (nonatomic, strong) NSString<Optional> *topicType;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSString<Optional> *topicLogo;
@property (nonatomic, strong) NSString<Optional> *topicChange;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *topicName;
@property (nonatomic, strong) NSString<Optional> *fromGroupTopicId;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) GetMemberIdRequest_personalConfig<Optional> *personalConfig;
@property (nonatomic, strong) NSString<Optional> *members;
@property (nonatomic, strong) NSString<Optional> *topicGroup;
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *speak;
-(ContactMemberContactsRequestItem_Data_Gcontacts_Groups *)toContactsGroup;
@end

@interface GetMemberIdRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *memberId;
@property (nonatomic, strong) GetMemberIdRequest_topic<Optional> *topic;
@end

@interface GetMemberIdRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetMemberIdRequestItem_data<Optional> *data;
@end

@interface GetMemberIdRequest : YXGetRequest
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *fromGroupTopicId;
@end
