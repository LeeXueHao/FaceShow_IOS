//
//  SubmitUserHomeworkRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SubmitUserHomeworkRequest.h"

@implementation SubmitUserHomeworkRequest_data
@end

@implementation SubmitUserHomeworkRequestItem
@end

@implementation SubmitUserHomeworkRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.submitUserHomework";
    }
    return self;
}
@end
