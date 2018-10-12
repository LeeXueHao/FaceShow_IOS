//
//  ConfigManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ConfigManager : JSONModel
+ (ConfigManager *)sharedInstance;

@property (nonatomic, strong) NSString<Optional> *server;      // 切换正式、测试环境 Url Header
@property (nonatomic, strong) NSString<Optional> *loginServer;
@property (nonatomic, strong) NSString<Optional> *server1_1;
@property (nonatomic, strong) NSString<Optional> *easygo;      // 切换正式、测试环境 头像上传路径
@property (nonatomic, strong) NSString<Optional> *pcAddress;

@property (nonatomic, strong) NSString<Ignore> *appName;
@property (nonatomic, strong) NSString<Ignore> *clientVersion;

@property (nonatomic, strong) NSString<Ignore> *deviceID;
@property (nonatomic, strong) NSString<Ignore> *deviceType;
@property (nonatomic, strong) NSString<Ignore> *deviceName;
@property (nonatomic, strong) NSString<Ignore> *deviceModelName;

@property (nonatomic, strong) NSString<Ignore> *osType;
@property (nonatomic, strong) NSString<Ignore> *osVersion;

@end
