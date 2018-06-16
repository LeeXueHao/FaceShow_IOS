//
//  GetUserTasksProgressRankRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserTasksProgressRankRequest.h"

@implementation GetUserTasksProgressRankRequestItem_element
@end

@implementation GetUserTasksProgressRankRequestItem_userRank
@end

@implementation GetUserTasksProgressRankRequestItem_data
@end

@implementation GetUserTasksProgressRankRequestItem
@end

@implementation GetUserTasksProgressRankRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.getUserTaskProgressRank";
    }
    return self;
}

@end
