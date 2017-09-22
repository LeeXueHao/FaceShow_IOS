//
//  GetNoticeListRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetNoticeListRequest.h"

@implementation GetNoticeListRequestItem_Notice
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"noticeId"}];
}
@end

@implementation GetNoticeListRequestItem_Data
@end

@implementation GetNoticeListRequestItem
@end

@implementation GetNoticeListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.notice.list";
    }
    return self;
}
@end
