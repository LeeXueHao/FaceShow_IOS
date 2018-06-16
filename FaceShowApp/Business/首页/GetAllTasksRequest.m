//
//  GetAllTasksRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetAllTasksRequest.h"

@implementation GetAllTasksRequestItem_task
@end

@implementation GetAllTasksRequestItem_interactType
@end

@implementation GetAllTasksRequestItem_data
@end

@implementation GetAllTasksRequestItem
@end


@implementation GetAllTasksRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead =  [ConfigManager sharedInstance].server1_1;
        self.method = @"app.clazs.getAllTasks";
    }
    return self;
}
@end
