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
#import <sys/utsname.h>
BOOL mockFrameworkOn = NO;
BOOL testFrameworkOn = NO;

#ifdef HuBeiApp

#ifdef DEBUG
NSString * const kServer = @"http://hbyxb.ymd.yanxiu.com/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://hbyxb.ymd.yanxiu.com/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://hbyxb.ymd.yanxiu.com/uc/appLogin";
NSString * const kQuickLoginServer = @"http://hbyxb.ymd.yanxiu.com/uc/AppCodeLogin";
NSString * const kEasygoServer = @"http://hbyxb.ymd.yanxiu.com/easygo/multiUpload";
NSString * const kPCAddress = @"http://hbyxb.ymd.yanxiu.com/sd/101";
#else
NSString * const kServer = @"http://jspx1.e21.cn/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://jspx1.e21.cn/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://jspx1.e21.cn/uc/appLogin";
NSString * const kQuickLoginServer = @"http://jspx1.e21.cn/uc/AppCodeLogin";
NSString * const kEasygoServer = @"http://jspx1.e21.cn/easygo/multiUpload";
NSString * const kPCAddress = @"http://jspx1.e21.cn/sd/101";
#endif

#else

#ifdef DEBUG
NSString * const kServer = @"http://yxb.yanxiu.com/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://yxb.yanxiu.com/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://pp.yanxiu.com/uc/appLogin";
NSString * const kQuickLoginServer = @"http://pp.yanxiu.com/uc/AppCodeLogin";
NSString * const kEasygoServer = @"http://b.yanxiu.com/easygo/multiUpload";
NSString * const kPCAddress = @"http://yxb.yanxiu.com/sd/100";

//NSString * const kServer = @"http://orz.yanxiu.com/pxt/platform/data.api";
//NSString * const kServer1_1 = @"http://orz.yanxiu.com/pxt/v1.1/platform/data.api";
//NSString * const kLoginServer = @"http://orz.yanxiu.com/uc/appLogin";
//NSString * const kQuickLoginServer = @"http://orz.yanxiu.com/uc/AppCodeLogin";
//NSString * const kEasygoServer = @"http://orz.yanxiu.com/easygo/multiUpload";
//NSString * const kPCAddress = @"http://orz.yanxiu.com/sd/1";
#else
//NSString * const kServer = @"http://yxb.yanxiu.com/pxt/platform/data.api";
//NSString * const kServer1_1 = @"http://yxb.yanxiu.com/pxt/v1.1/platform/data.api";
//NSString * const kLoginServer = @"http://pp.yanxiu.com/uc/appLogin";
//NSString * const kQuickLoginServer = @"http://pp.yanxiu.com/uc/AppCodeLogin";
//NSString * const kEasygoServer = @"http://b.yanxiu.com/easygo/multiUpload";
//NSString * const kPCAddress = @"http://yxb.yanxiu.com/sd/100";
NSString * const kServer = @"http://orz.yanxiu.com/pxt/platform/data.api";
NSString * const kServer1_1 = @"http://orz.yanxiu.com/pxt/v1.1/platform/data.api";
NSString * const kLoginServer = @"http://orz.yanxiu.com/uc/appLogin";
NSString * const kQuickLoginServer = @"http://orz.yanxiu.com/uc/AppCodeLogin";
NSString * const kEasygoServer = @"http://orz.yanxiu.com/easygo/multiUpload";
NSString * const kPCAddress = @"http://orz.yanxiu.com/sd/1";

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

- (NSString *)quickLoginServer{
    return kQuickLoginServer;
}

- (NSString *)easygo {
    return kEasygoServer;
}

- (NSString *)pcAddress {
    return kPCAddress;
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

- (NSString *)deviceModelName {
    if (!_deviceModelName) {
        _deviceModelName = [self getDeviceModelName];
    }
    return _deviceModelName;
}

- (NSString *)getDeviceModelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";

    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";

    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";

    return deviceModel;
}



@end
