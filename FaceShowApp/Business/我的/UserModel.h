//
//  UserModel.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoRequest.h"
@interface UserModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *realName;
@property (nonatomic, copy) NSString<Optional> *mobilePhone;
@property (nonatomic, copy) NSString<Optional> *email;

@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *stage;
@property (nonatomic, copy) NSString<Optional> *subjectID;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *userStatus;
@property (nonatomic, copy) NSString<Optional> *ucnterID;
@property (nonatomic, copy) NSString<Optional> *sexID;
@property (nonatomic, copy) NSString<Optional> *sex;
@property (nonatomic, copy) NSString<Optional> *school;
@property (nonatomic, copy) NSString<Optional> *avatarUrl;

@property (nonatomic, copy) NSString<Optional> *token;

+ (UserModel *)modelFromRawData:(UserInfoRequestItem_Data *)rawData;
@end
