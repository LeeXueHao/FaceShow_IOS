//
//  ConfigManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ConfigManager.h"
#import <FCUUID.h>
#import <UIDevice+HardwareName.h>

BOOL mockFrameworkOn = NO;
BOOL testFrameworkOn = NO;

#ifdef HuBeiApp

#ifdef DEBUG
NSString * const kServer = @"http://hbyxb.ymd.yanxiu.com/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://hbyxb.ymd.yanxiu.com/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://hbyxb.ymd.yanxiu.com/uc/appLogin";
NSString * const kEasygoServer = @"http://hbyxb.ymd.yanxiu.com/easygo/multiUpload";
NSString * const kQiNiuUpload = @"http://pavlal4my.bkt.clouddn.com";
#else
NSString * const kServer = @"http://jspx1.e21.cn/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://jspx1.e21.cn/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://jspx1.e21.cn/uc/appLogin";
NSString * const kEasygoServer = @"http://jspx1.e21.cn/easygo/multiUpload";
NSString * const kQiNiuUpload = @"http://hubeiyxb.jsyxw.cn";
#endif

#else

#ifdef DEBUG
NSString * const kServer = @"http://orz.yanxiu.com/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://orz.yanxiu.com/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://orz.yanxiu.com/uc/appLogin";
NSString * const kEasygoServer = @"http://orz.yanxiu.com/easygo/multiUpload";
NSString * const kQiNiuUpload = @"http://p2xuvkfak.bkt.clouddn.com";
#else
NSString * const kServer = @"http://yxb.yanxiu.com/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://yxb.yanxiu.com/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://pp.yanxiu.com/uc/appLogin";
NSString * const kEasygoServer = @"http://b.yanxiu.com/easygo/multiUpload";
NSString * const kQiNiuUpload = @"http://niuugcupload.yanxiu.com";
#endif

#endif

@implementation ConfigManager
+ (ConfigManager *)sharedInstance {
    static dispatch_once_t once;
    static ConfigManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[ConfigManager alloc]init];
    });
    
    return sharedInstance;
}

#pragma mark - properties
- (NSString *)server {
    return kServer;
}

- (NSString *)server1_1 {
    return kServer1_1;
}

- (NSString *)loginServer {
    return kLoginServer;
}

- (NSString *)easygo {
    return kEasygoServer;
}

- (NSString *)qiNiuUpLoad {
    return kQiNiuUpload;
}

- (NSString *)appName {
    if (!_appName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return _appName;
}

- (NSString *)clientVersion {
    if (!_clientVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _clientVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _clientVersion;
}

- (NSString *)deviceID {
    return [FCUUID uuidForDevice];
}

- (NSString *)deviceType {
    if (!_deviceType) {
        _deviceType = [[UIDevice currentDevice] platform];
    }
    return _deviceType;
}

- (NSString *)osType {
    return @"ios";
}

- (NSString *)osVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)deviceName {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"iPad";
    } else {
        return @"iPhone";
    }
}

@end
