//
//  GetUserTaskProgressRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserTaskProgressRequest.h"

@implementation GetUserTaskProgressRequestItem_interactType
@end

@implementation GetUserTaskProgressRequestItem_data
@end

@implementation GetUserTaskProgressRequestItem
@end

@implementation GetUserTaskProgressRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.getUserTaskProgress";
    }
    return self;
}

@end
