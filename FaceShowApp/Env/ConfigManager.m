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

@implementation ConfigManager
+ (ConfigManager *)sharedInstance {
    static dispatch_once_t once;
    static ConfigManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[ConfigManager alloc]initWithConfigFile:@"Config"];
        [sharedInstance setupServerEnv];
    });
    
    return sharedInstance;
}

- (id)initWithConfigFile:(NSString *)filename {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filepath];
    NSError *error = nil;
    self = [super initWithDictionary:dict error:&error];
    if (error) {
        // make sure works even without a config plist
        self = [super init];
    }
    return self;
}

- (void)setupServerEnv {
    NSString *envPath = [[NSBundle mainBundle]pathForResource:@"env_config" ofType:@"json"];
    NSData *envData = [NSData dataWithContentsOfFile:envPath];
    NSDictionary *envDic = [NSJSONSerialization JSONObjectWithData:envData options:kNilOptions error:nil];
    self.server = [envDic valueForKey:@"server"];
    self.loginServer = [envDic valueForKey:@"loginServer"];
    self.easygo = [envDic valueForKey:@"easygo"];
}

#pragma mark - properties
//- (NSString *)server {
//    if ([_server hasSuffix:@"/"]) {
//        return _server;
//    } else {
//        return [_server stringByAppendingString:@"/"];
//    }
//}

- (NSString *)appName {
    if (!_appName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDictionary objectForKey:@"CFBundleName"];
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
