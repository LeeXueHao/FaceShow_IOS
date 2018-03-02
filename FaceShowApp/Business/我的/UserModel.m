//
//  UserModel.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserModel.h"

NSString * const kClassDidSelectNotification = @"kClassDidSelectNotification";

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
    model.sexName = userInfo.sexName;
    if (userInfo.imTokenInfo) {
        model.imInfo = userInfo.imTokenInfo;
    }
    return model;
}
- (void)updateFromUserInfo:(GetUserInfoRequestItem_Data *)userInfo {
    self.userID = userInfo.userId;
    self.realName = userInfo.realName;
    self.mobilePhone = userInfo.mobilePhone;
    self.email = userInfo.email;
    self.stageID = userInfo.stage;
    self.subjectID = userInfo.subject;
    self.sexID = userInfo.sex;
    self.userStatus = userInfo.userStatus;
    self.ucnterID = userInfo.ucnterId;
    self.school = userInfo.school;
    self.avatarUrl = userInfo.avatar;
    self.stageName = userInfo.stageName;
    self.subjectName = userInfo.subjectName;
    self.sexName = userInfo.sexName;
    if (userInfo.imTokenInfo) {
        self.imInfo = userInfo.imTokenInfo;
    }
}
@end
