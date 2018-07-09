//
//  UserInfoNameModel.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
//头像-0姓名-1手机号-2性别-3学段学科-4省市区-5学校-6身份证号-7子项目编号-8子项目名称-9承训单位-10学校所在区域-11学校类别-12民族-13职称-14职务(非必填)-15最高学历-16毕业院校-17所学专业-18电话(非必填)-19电子邮件(非必填)
typedef NS_ENUM(NSInteger, UserInfoNameType) {
    UserInfoNameType_RealName = 0,
    UserInfoNameType_MobilePhone = 1,
    UserInfoNameType_Sex = 2,
    UserInfoNameType_SubjectStage = 3,
    UserInfoNameType_Provinces = 4,
    UserInfoNameType_School = 5,
    UserInfoNameType_IdCard = 6,
    UserInfoNameType_ChildProjectId = 7,
    UserInfoNameType_ChildProjectName = 8,
    UserInfoNameType_Organizer = 9,
    UserInfoNameType_Area = 10,
    UserInfoNameType_SchoolType = 11,
    UserInfoNameType_Nation = 12,
    UserInfoNameType_Title = 13,
    UserInfoNameType_Job = 14,
    UserInfoNameType_RecordEducation = 15,
    UserInfoNameType_Graduation = 16,
    UserInfoNameType_Professional = 17,
    UserInfoNameType_Telephone = 18,
    UserInfoNameType_Email = 19
};
@interface UserInfoNameModel : NSObject
+ (NSString *)userInfoName:(UserInfoNameType)type;
@end
