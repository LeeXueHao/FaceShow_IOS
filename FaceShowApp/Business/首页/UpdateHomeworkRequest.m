//
//  UpdateHomeworkRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpdateHomeworkRequest.h"

@implementation UpdateHomeworkRequestItem_data
@end

@implementation UpdateHomeworkRequestItem
@end

@implementation UpdateHomeworkRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.updateHomework";
    }
    return self;
}
@end
