//
//  BasicDataConfig.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BasicDataConfig.h"

#ifdef DEBUG
NSString * const kBasicDataServer = @"http://hbyxb.ymd.yanxiu.com/pxt/platform/data.api";
#else
NSString * const kBasicDataServer = @"http://jspx1.e21.cn/pxt/platform/data.api";
#endif

@implementation BasicDataConfig

@end
