//
//  GetNoticeDetailRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetNoticeDetailRequest.h"

@implementation GetNoticeDetailRequestItem_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"noticeId"}];
}
@end

@implementation GetNoticeDetailRequestItem
@end

@implementation GetNoticeDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"notice.detail";
    }
    return self;
}
@end
