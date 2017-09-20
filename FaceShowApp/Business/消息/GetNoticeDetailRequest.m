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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"noticeId" : @"id"}];
}
@end

@implementation GetNoticeDetailRequestItem
@end

@interface GetNoticeDetailRequest ()
@property (nonatomic, strong) NSString *method;
@end

@implementation GetNoticeDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://orz.yanxiu.com/pxt/platform/data.api";
        self.method = @"notice.detail";
    }
    return self;
}
@end
