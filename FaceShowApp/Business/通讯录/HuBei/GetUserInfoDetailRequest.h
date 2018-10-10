//
//  GetUserInfoDetailRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

//http://wiki.yanxiu.com/pages/viewpage.action?pageId=12323096#id-用户相关异步接口-3获取用户信息

@interface GetUserInfoDetailRequestItem_aui : JSONModel
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *idCard;
@property (nonatomic, strong) NSString<Optional> *province;
@property (nonatomic, strong) NSString<Optional> *city;
@property (nonatomic, strong) NSString<Optional> *country;
@property (nonatomic, strong) NSString<Optional> *area;
@property (nonatomic, strong) NSString<Optional> *schoolType;
@property (nonatomic, strong) NSString<Optional> *nation;
@property (nonatomic, strong) NSString<Optional> *recordeducation;
@property (nonatomic, strong) NSString<Optional> *graduation;
@property (nonatomic, strong) NSString<Optional> *professional;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *childprojectId;
@property (nonatomic, strong) NSString<Optional> *childprojectName;
@property (nonatomic, strong) NSString<Optional> *organizer;
@property (nonatomic, strong) NSString<Optional> *telephone;
@property (nonatomic, strong) NSString<Optional> *job;
@end

@interface GetUserInfoDetailRequestItem_Data : JSONModel
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *realName;
@property (nonatomic, copy) NSString<Optional> *mobilePhone;
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) NSString<Optional> *stage;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *userStatus;
@property (nonatomic, copy) NSString<Optional> *ucnterId;
@property (nonatomic, copy) NSString<Optional> *sex;
@property (nonatomic, copy) NSString<Optional> *school;
@property (nonatomic, copy) NSString<Optional> *avatar;
@property (nonatomic, copy) NSString<Optional> *stageName;
@property (nonatomic, copy) NSString<Optional> *subjectName;
@property (nonatomic, copy) NSString<Optional> *sexName;
@property (nonatomic, strong) GetUserInfoDetailRequestItem_aui<Optional> *aui;

- (NSString *)sexString;
@end

@interface GetUserInfoDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserInfoDetailRequestItem_Data<Optional> *data;
@end

@interface GetUserInfoDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString *userId;
@end
