//
//  UserInfoNameModel.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UserInfoNameModel.h"
@implementation UserInfoNameModel
+ (NSString *)userInfoName:(UserInfoNameType)type {
    switch (type) {
        case UserInfoNameType_RealName:
        {
            return @"姓名";
        }
            break;
        case UserInfoNameType_MobilePhone:
        {
            return @"手机号";
        }
            break;
        case UserInfoNameType_Sex:
        {
            return @"性别";
        }
            break;
        case UserInfoNameType_SubjectStage:
        {
            return @"学段学科";
        }
            break;
        case UserInfoNameType_Provinces:
        {
            return @"省市区";
        }
            break;
        case UserInfoNameType_School:
        {
            return @"学校";
        }
            break;
        case UserInfoNameType_IdCard:
        {
            return @"身份证号";
        }
            break;
        case UserInfoNameType_ChildProjectId:
        {
            return @"子项目编号";
        }
            break;
        case UserInfoNameType_ChildProjectName:
        {
            return @"子项目名称";
        }
            break;
        case UserInfoNameType_Organizer:
        {
            return @"承训单位";
        }
            break;
        case UserInfoNameType_Area:
        {
            return @"学校所在区域";
        }
            break;
        case UserInfoNameType_SchoolType:
        {
            return @"学校类别";
        }
            break;
        case UserInfoNameType_Nation:
        {
            return @"民族";
        }
            break;
        case UserInfoNameType_Title:
        {
            return @"职称";
        }
            break;
        case UserInfoNameType_Job:
        {
            return @"职务";
        }
            break;
        case UserInfoNameType_RecordEducation:
        {
            return @"最高学历";
        }
            break;
        case UserInfoNameType_Graduation:
        {
            return @"毕业院校";
        }
            break;
        case UserInfoNameType_Professional:
        {
            return @"所学专业";
        }
            break;
        case UserInfoNameType_Telephone:
        {
            return @"电话";
        }
            break;
        case UserInfoNameType_Email:
        {
            return @"电子邮件";
        }
            break;
    }
}
@end
