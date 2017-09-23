//
//  GetCourseCommentTitleRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetCourseCommentTitleRequest.h"

@implementation GetCourseCommentTitleRequestItem_data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end

@implementation GetCourseCommentTitleRequestItem

@end

@implementation GetCourseCommentTitleRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.getComment";
    }
    return self;
}
@end
