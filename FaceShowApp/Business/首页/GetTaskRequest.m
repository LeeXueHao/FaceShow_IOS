//
//  GetTaskRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetTaskRequest.h"

@implementation GetTaskRequestItem_Task
@end

@implementation GetTaskRequestItem
@end

@implementation GetTaskRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.getTasks";
    }
    return self;
}
@end
