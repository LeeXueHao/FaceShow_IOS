//
//  UpgradeConfig.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpgradeConfig.h"

NSString * const kProductLine = @"4";

#ifdef DEBUG
NSString * const kUpgradeServer = @"http://test.hwk.yanxiu.com/app/log/uploadDeviceLog/release.do";
NSString * const kUpgradeMode = @"test";
#else
NSString * const kUpgradeServer = @"http://appadmin.yanxiu.com/app/log/uploadDeviceLog/release.do";
NSString * const kUpgradeMode = @"release";
#endif

@implementation UpgradeConfig

@end
