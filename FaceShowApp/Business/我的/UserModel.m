//
//  UserModel.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (UserModel *)modelFromUserInfo:(GetUserInfoRequestItem_Data *)userInfo {
    UserModel *model = [[UserModel alloc]init];
    model.userID = userInfo.userId;
    model.realName = userInfo.realName;
    model.mobilePhone = userInfo.mobilePhone;
    model.email = userInfo.email;
    model.stageID = userInfo.stage;
    model.subjectID = userInfo.subject;
    model.sexID = userInfo.sex;
    model.userStatus = userInfo.userStatus;
    model.ucnterID = userInfo.ucnterId;
    model.school = userInfo.school;
    model.avatarUrl = userInfo.avatar;
    model.stageName = userInfo.stageName;
    model.subjectName = userInfo.subjectName;
    model.sexName = userInfo.sex.integerValue == 0 ? @"女" : @"男";
    return model;
}
@end
