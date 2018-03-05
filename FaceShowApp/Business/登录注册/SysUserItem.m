//
//  SysUserItem.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SysUserItem.h"

@implementation SysUserItem
- (UserModel *)toUserModel {
    UserModel *model = [[UserModel alloc]init];
    model.userID = self.userId;
    model.realName = self.realName;
    model.mobilePhone = self.mobilePhone;
    model.stageID = self.stage;
    model.stageName = self.stageName;
    model.subjectID = self.subject;
    model.subjectName = self.subjectName;
    model.sexID = self.sex;
    model.sexName = self.sexName;
    return model;
}
@end
