//
//  UserModel.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (UserModel *)modelFromRawData:(UserInfoRequestItem_Data *)rawData {
    UserModel *model = [[UserModel alloc]init];
    model.userID = rawData.userId;
    model.realName = rawData.realName;
    model.mobilePhone = rawData.mobilePhone;
    model.email = rawData.email;
    
    model.stageID = rawData.stage;
    model.subjectID = rawData.subject;
    model.sexID = rawData.sex;
    
    
    model.userStatus = rawData.userStatus;
    model.ucnterID = rawData.ucnterId;
    model.school = rawData.school;
    model.avatarUrl = rawData.avatar;
    
#warning 自定义
    model.stage = @"高中";
    model.subject = @"语文";
    model.sex = @"男";
    model.avatarUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505973205506&di=7f8d5b7bd167681b2122b7bd6134eddc&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3D72d8ddc8aad3fd1f365caa3e057e0929%2F902397dda144ad34a9d1c961d2a20cf430ad85ee.jpg";


    return model;
}
@end
