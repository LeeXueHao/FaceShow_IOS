//
//  PageNameMappingTable.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PageNameMappingTable.h"

static NSDictionary *mappingDict = nil;

@implementation PageNameMappingTable
+ (NSString *)pageNameForViewControllerName:(NSString *)vcName {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        mappingDict = @{@"LoginViewController":@"登录",
                        @"ForgotPasswordViewController":@"忘记密码",
//                        @"ClassSelectionViewController":@"切换班级",
                        @"MainPageViewController":@"首页",
                        @"ScanCodeViewController":@"扫一扫",
                        @"ScanCodeResultViewController":@"签到结果",
                        @"MessageViewController":@"通知",
                        @"MessageDetailViewController":@"通知详情",
                        @"ContactsViewController":@"通讯录",
//                        @"ContactsDetailViewController":@"学员详情",
                        @"ClassMomentViewController":@"班级圈",
                        @"PublishMomentViewController":@"发布班级圈",
                        @"PhotoBrowserController":@"图片删除",
                        @"CourseListViewController":@"课程",
                        @"CourseDetailViewController":@"课程详情",
                        @"CourseBriefViewController":@"课程简介",
                        @"ProfessorDetailViewController":@"讲师简介",
                        @"CourseCommentViewController":@"讨论",
                        @"QuestionnaireViewController":@"问卷投票-未完成",
                        @"QuestionnaireResultViewController":@"问卷投票",
                        @"SignInDetailViewController":@"签到详情",
                        @"ResourceListViewController":@"资源",
                        @"ResourceDisplayViewController":@"资源详情",
                        @"ScheduleViewController":@"日程",
                        @"MineViewController":@"我的",
                        @"UserInfoViewController":@"我的资料",
                        @"ModifyNameViewController":@"修改姓名",
                        @"StageSubjectViewController":@"修改学段学科",
                        @"SignInRecordViewController":@"签到记录"
                        };
    });
    return [mappingDict valueForKey:vcName];
}
@end
