//
//  GetTasksRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetTasksRequest.h"

@implementation GetTasksRequestItem_task
@end

@implementation GetTasksRequestItem
@end

@implementation GetTasksRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.clazs.getTasks";
    }
    return self;
}
@end
