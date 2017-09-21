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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"noticeId" : @"id"}];
}
@end

@implementation GetNoticeListRequestItem
@end

@interface GetNoticeListRequest ()
@end

@implementation GetNoticeListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://orz.yanxiu.com/pxt/platform/data.api";
        self.method = @"app.notice.list";
    }
    return self;
}
@end
