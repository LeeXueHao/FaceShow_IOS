//
//  GetCourseRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetCourseRequest.h"

@implementation GetCourseRequestItem_InteractStep
@end

@implementation GetCourseRequestItem_AttachmentInfo
@end

@implementation GetCourseRequestItem_LecturerInfo
@end

@implementation GetCourseRequestItem_Course
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"courseId" : @"id"}];
}
@end

@implementation GetCourseRequestItem_Data
@end

@implementation GetCourseRequestItem
@end

@interface GetCourseRequest ()
@property (nonatomic, strong) NSString *method;
@end

@implementation GetCourseRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://orz.yanxiu.com/pxt/platform/data.api";
        self.method = @"app.course.getCourse";
    }
    return self;
}

@end
