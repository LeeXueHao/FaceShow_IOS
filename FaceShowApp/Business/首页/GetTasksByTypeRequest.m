//
//  GetTasksByTypeRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetTasksByTypeRequest.h"

@implementation GetTasksByTypeRequestItem_task
@end

@implementation GetTasksByTypeRequestItem
@end

@implementation GetTasksByTypeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.clazs.getTasks";
    }
    return self;
}
@end
