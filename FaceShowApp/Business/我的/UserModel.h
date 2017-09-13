//
//  UserModel.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HttpBaseRequestItem_info.h"

@interface UserModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *backgroundImageUrl;
@property (nonatomic, strong) NSString<Optional> *portraitUrl;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *districtID;
@property (nonatomic, strong) NSString<Optional> *provinceID;
@property (nonatomic, strong) NSString<Optional> *cityID;
@property (nonatomic, strong) NSString<Optional> *stageID;
@property (nonatomic, strong) NSString<Optional> *subjectID;
@property (nonatomic, strong) NSString<Optional> *truename;
@property (nonatomic, strong) NSString<Optional> *oldUserId;//用户中心id
@property (nonatomic, strong) NSString<Optional> *userID;
@property (nonatomic, strong) NSString<Optional> *experience;//工作年限
@property (nonatomic, strong) NSString<Optional> *role;//角色
@property (nonatomic, strong) NSString<Optional> *gender;//性别

@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, assign) BOOL isTaged;  //NO--未设置学段学科，YES--已设置
@property (nonatomic, assign) BOOL isSankeUser;  // YES--是三科用户
@property (nonatomic, assign) BOOL isAnonymous;

+ (UserModel *)modelFromRawData:(HttpBaseRequestItem_info *)rawData;
@end
