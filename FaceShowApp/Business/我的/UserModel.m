//
//  UserModel.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserModel.h"
#import "AreaManager.h"
NSString * const kClassDidSelectNotification = @"kClassDidSelectNotification";
@implementation UserModel_Aui
@end
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
    UserModel_Aui *aui = [[UserModel_Aui alloc] init];
    aui.userId = userInfo.aui.userId;
    aui.idCard = userInfo.aui.idCard;
    aui.province = userInfo.aui.province;
    aui.city = userInfo.aui.city;
    aui.country = userInfo.aui.country;
    aui.area = userInfo.aui.area;
    aui.schoolType = userInfo.aui.schoolType;
    aui.nation = userInfo.aui.nation;
    aui.title = userInfo.aui.title;
    aui.recordeducation = userInfo.aui.recordeducation;
    aui.graduation = userInfo.aui.graduation;
    aui.professional = userInfo.aui.professional;
    
    aui.childProjectId = userInfo.aui.childprojectId;
    aui.childProjectName = userInfo.aui.childprojectName;
    aui.organizer = userInfo.aui.organizer;
    aui.job = userInfo.aui.job;
    aui.telephone = userInfo.aui.telephone;
    
    __block Area *province = nil;
    [[AreaManager sharedInstance].areaModel.data enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:aui.province]) {
            province = obj;
            aui.provinceName = obj.name;
            *stop = YES;
        }
    }];
    __block Area *city = nil;
    [province.sub enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:aui.city]) {
            city = obj;
            aui.cityName = obj.name;
            *stop = YES;
        }
    }];
    
    __block Area *country = nil;
    [city.sub enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:aui.country]) {
            country = obj;
            aui.countryName = obj.name;
            *stop = YES;
        }
    }];
    model.aui = aui;
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
    UserModel_Aui *aui = [[UserModel_Aui alloc] init];
    aui.userId = userInfo.aui.userId;
    aui.idCard = userInfo.aui.idCard;
    aui.province = userInfo.aui.province;
    aui.city = userInfo.aui.city;
    aui.country = userInfo.aui.country;
    aui.area = userInfo.aui.area;
    aui.schoolType = userInfo.aui.schoolType;
    aui.nation = userInfo.aui.nation;
    aui.title = userInfo.aui.title;
    aui.recordeducation = userInfo.aui.recordeducation;
    aui.graduation = userInfo.aui.graduation;
    aui.professional = userInfo.aui.professional;
    
    aui.childProjectId = userInfo.aui.childprojectId;
    aui.childProjectName = userInfo.aui.childprojectName;
    aui.organizer = userInfo.aui.organizer;
    aui.job = userInfo.aui.job;
    aui.telephone = userInfo.aui.telephone;
    
    __block Area *province = nil;
    [[AreaManager sharedInstance].areaModel.data enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:aui.province]) {
            province = obj;
            aui.provinceName = obj.name;
            *stop = YES;
        }
    }];
    __block Area *city = nil;
    [province.sub enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:aui.city]) {
            city = obj;
            aui.cityName = obj.name;
            *stop = YES;
        }
    }];
    
    __block Area *country = nil;
    [city.sub enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:aui.country]) {
            country = obj;
            aui.countryName = obj.name;
            *stop = YES;
        }
    }];
    self.aui = aui;
}
@end
