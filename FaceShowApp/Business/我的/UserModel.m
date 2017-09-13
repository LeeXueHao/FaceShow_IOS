//
//  UserModel.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (UserModel *)modelFromRawData:(HttpBaseRequestItem_info *)rawData {
    UserModel *model = [[UserModel alloc]init];
    model.backgroundImageUrl = rawData.userInfo.backgroundimage;
    model.portraitUrl = rawData.userInfo.icon;
    model.name = rawData.userInfo.name;
    model.nickname = rawData.userInfo.nickname;
    model.districtID = rawData.userInfo.quxian;
    model.provinceID = rawData.userInfo.sheng;
    model.cityID = rawData.userInfo.shi;
    model.stageID = rawData.userInfo.stage;
    model.subjectID = rawData.userInfo.subject;
    model.truename = rawData.userInfo.truename;
    model.oldUserId = rawData.userInfo.olduserid;
    model.userID = rawData.userInfo.userid;
    model.token = rawData.token;
    model.isTaged = [rawData.is_taged isEqualToString:@"1"];
    model.isSankeUser = [rawData.is_sanke isEqualToString:@"1"];
    model.isAnonymous = [rawData.is_anonymous isEqualToString:@"1"];
    model.experience = rawData.userInfo.experience;
    model.role = rawData.userInfo.role;
    model.gender = rawData.userInfo.sex;
    return model;
}
@end
