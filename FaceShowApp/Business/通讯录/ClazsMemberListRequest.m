//
//  ClazsMemberListRequest.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClazsMemberListRequest.h"

@implementation ClazsMemberListRequestItem_Data_Students
@end

@implementation ClazsMemberListRequestItem_Data
@end

@implementation ClazsMemberListRequestItem
@end

@implementation ClazsMemberListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.sysUser.getClazsMember";
    }
    return self;
}
@end
