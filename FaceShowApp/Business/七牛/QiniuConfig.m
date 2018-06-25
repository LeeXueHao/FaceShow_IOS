//
//  QiniuConfig.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QiniuConfig.h"

#ifdef HuBeiApp

#ifdef DEBUG
NSString * const kQiniuServer = @"http://hbyxb.ymd.yanxiu.com/7up/platform/data.api";
#else
NSString * const kQiniuServer = @"http://jspx1.e21.cn/7up/platform/data.api";
#endif

#else

#ifdef DEBUG
NSString * const kQiniuServer = @"http://orz.yanxiu.com/7up/platform/data.api";
#else
NSString * const kQiniuServer = @"http://niuugcupload.yanxiu.com/7up/platform/data.api";
#endif

#endif

@implementation QiniuConfig

@end
