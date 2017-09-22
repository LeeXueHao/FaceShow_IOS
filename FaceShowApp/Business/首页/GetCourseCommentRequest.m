//
//  GetCourseCommentRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetCourseCommentRequest.h"

@implementation GetCourseCommentRequestItem_element
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation GetCourseCommentRequestItem_data

@end

@implementation GetCourseCommentRequestItem

@end

@implementation GetCourseCommentRequest
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"callbackValue"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.commentRecords";
    }
    return self;
}
@end
