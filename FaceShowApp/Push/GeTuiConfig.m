//
//  GeTuiConfig.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GeTuiConfig.h"

#ifdef HuBeiApp

#ifdef DEBUG
NSString * const kGeTuiAppID = @"zsL5bj1X9v8KWc3yTXn8A5";
NSString * const kGeTuiAppKey = @"uOnWCMeI0n5EbbIbocUAa6";
NSString * const kGeTuiAppSecret = @"IonSC3eY6F6wCZRBihzDW7";
#else
NSString * const kGeTuiAppID = @"Sssgn092pl9ntFfRDexmH3";
NSString * const kGeTuiAppKey = @"s3m6mOyi0W8oCX32t3GAe4";
NSString * const kGeTuiAppSecret = @"8kFP0s3Hfe7y7PXkJEllJ6";
#endif

#else

#ifdef DEBUG
NSString * const kGeTuiAppID = @"9Ng5XgUmPl7ph0Ms20Y3G5";
NSString * const kGeTuiAppKey = @"vzvNLfGIUP8h8aj6waobvA";
NSString * const kGeTuiAppSecret = @"pqVYEPxb6AAtvel7UHJsd2";
#else
NSString * const kGeTuiAppID = @"AzFI1hszEo6U21wtdrn5K8";
NSString * const kGeTuiAppKey = @"EvZ1LJLZ0z5HyzqWvRFWG2";
NSString * const kGeTuiAppSecret = @"lydBIygOzJ9Rxm9aVBK8P6";
#endif

#endif


@implementation GeTuiConfig

@end
