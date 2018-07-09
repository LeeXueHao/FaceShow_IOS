//
//  UserModel.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GetUserInfoRequest.h"
#import "GetCurrentClazsRequest.h"

extern NSString * const kClassDidSelectNotification;
@interface UserModel_Aui : JSONModel
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *idCard;
@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *country;
@property (nonatomic, copy) NSString<Optional> *area;
@property (nonatomic, copy) NSString<Optional> *schoolType;
@property (nonatomic, copy) NSString<Optional> *nation;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *recordeducation;
@property (nonatomic, copy) NSString<Optional> *graduation;
@property (nonatomic, copy) NSString<Optional> *professional;

@property (nonatomic, copy) NSString<Optional> *childProjectId;
@property (nonatomic, copy) NSString<Optional> *childProjectName;
@property (nonatomic, copy) NSString<Optional> *organizer;
@property (nonatomic, copy) NSString<Optional> *job;
@property (nonatomic, copy) NSString<Optional> *telephone;


@property (nonatomic, copy) NSString<Ignore> *provinceName;
@property (nonatomic, copy) NSString<Ignore> *cityName;
@property (nonatomic, copy) NSString<Ignore> *countryName;
@end

@interface UserModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *realName;
@property (nonatomic, copy) NSString<Optional> *mobilePhone;
@property (nonatomic, copy) NSString<Optional> *email;

@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *stageName;
@property (nonatomic, copy) NSString<Optional> *subjectID;
@property (nonatomic, copy) NSString<Optional> *subjectName;
@property (nonatomic, copy) NSString<Optional> *userStatus;
@property (nonatomic, copy) NSString<Optional> *ucnterID;
@property (nonatomic, copy) NSString<Optional> *sexID;
@property (nonatomic, copy) NSString<Optional> *sexName;
@property (nonatomic, copy) NSString<Optional> *school;
@property (nonatomic, copy) NSString<Optional> *avatarUrl;

@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *passport;

@property (nonatomic, strong) UserModel_Aui<Optional> *aui;

@property (nonatomic, strong) GetUserInfoRequestItem_imTokenInfo<Optional> *imInfo;

@property (nonatomic, strong) GetCurrentClazsRequestItem<Optional> *projectClassInfo;

+ (UserModel *)modelFromUserInfo:(GetUserInfoRequestItem_Data *)userInfo;
- (void)updateFromUserInfo:(GetUserInfoRequestItem_Data *)userInfo;
@end
