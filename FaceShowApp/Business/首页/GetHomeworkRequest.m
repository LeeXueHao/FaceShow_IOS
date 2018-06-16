//
//  GetHomeworkRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetHomeworkRequest.h"


@implementation GetHomeworkRequestItem_attachmentInfo
@end

@implementation GetHomeworkRequestItem_homework
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end

@implementation GetHomeworkRequestItem_userHomework
@end

@implementation GetHomeworkRequestItem_data
@end

@implementation GetHomeworkRequestItem
@end

@implementation GetHomeworkRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.interact.getHomework";
    }
    return self;
}
@end
