//
//  GetCourseListRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetCourseListRequest.h"

@implementation GetCourseListRequestItem_LecturerInfo
@end

@implementation GetCourseListRequestItem_coursesList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"courseId"}];
}
@end

@implementation GetCourseListRequestItem_courses

@end

@implementation GetCourseListRequestItem_data

@end

@implementation GetCourseListRequestItem

@end

@implementation GetCourseListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.courses";
    }
    return self;
}
@end
