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

@property (nonatomic, strong) NSString<Optional> *easygo;      // 切换正式、测试环境 头像上传路径


@property (nonatomic, strong) NSString<Ignore> *appName;
@property (nonatomic, strong) NSString<Ignore> *clientVersion;

@property (nonatomic, strong) NSString<Ignore> *deviceID;
@property (nonatomic, strong) NSString<Ignore> *deviceType;
@property (nonatomic, strong) NSString<Ignore> *deviceName;

@property (nonatomic, strong) NSString<Ignore> *osType;
@property (nonatomic, strong) NSString<Ignore> *osVersion;

@property (nonatomic, strong) NSNumber<Optional> *mockFrameworkOn;
@property (nonatomic, strong) NSNumber<Optional> *testFrameworkOn;

@property (nonatomic, strong) NSString<Optional> *TalkingDataAppID;
@property (nonatomic, strong) NSString<Optional> *channel;

#pragma mark - 三方登录
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthQQAppid;
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthQQAppKey;
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthWeixinAppid;
@property (nonatomic, strong) NSString<Optional> *YXSSOAuthWeixinAppSecret;
#pragma mark - 个推
@property (nonatomic, strong) NSString<Optional> *GeTuiAppId_Dev;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppKey_Dev;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppSecret_Dev;

@property (nonatomic, strong) NSString<Optional> *GeTuiAppId_Rel;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppKey_Rel;
@property (nonatomic, strong) NSString<Optional> *GeTuiAppSecret_Rel;
@end
