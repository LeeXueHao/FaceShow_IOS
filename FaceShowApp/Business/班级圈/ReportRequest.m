//
//  ReportRequest.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReportRequest.h"

@implementation ReportRequestItem
@end

@implementation ReportRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://mobile.yanxiu.com/api/common/report";
    }
    return self;
}
@end
