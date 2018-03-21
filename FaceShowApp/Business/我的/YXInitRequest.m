//
//  YXInitRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXInitRequest.h"
#import "NSString+YXString.h"

NSString *const YXInitSuccessNotification = @"kYXInitSuccessNotification";

@implementation YXInitRequestItem_Property

@end

@implementation YXInitRequestItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"iid"}];
}

- (BOOL)isTest
{
    if ([self.targetenv isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isForce
{
    if ([self.upgradetype isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end

@implementation YXInitRequestItem

@end

@implementation YXInitRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.token = nil;
        _productLine = @"4";
        _did = [ConfigManager sharedInstance].deviceID;
        _brand = [ConfigManager sharedInstance].deviceType;
        [self setCurrentNetType];
        
        _osModel = @"ios";
        _osVer = [UIDevice currentDevice].systemVersion;
        _appVersion = [ConfigManager sharedInstance].clientVersion;
        _content = @"";
        _operType = @"app.upload.log";
        _phone = [UserManager sharedInstance].userModel.mobilePhone? :@"";
        _remoteIp = @"";
        _mode = [ConfigManager sharedInstance].mode;
        _debugtoken = @"";
        _osType = @"1";
        self.urlHead = [ConfigManager sharedInstance].initializeUrl;
    }

    return self;
}

- (void)setCurrentNetType
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus]) {
        case ReachableViaWiFi:
            _nettype = @"1";
            break;
        case ReachableViaWWAN:
            _nettype = @"0";
            break;
        case NotReachable:
        default:
            break;
    }
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"os" : @"osModel"}];
}
@end


@interface YXInitHelper ()

@property (nonatomic, strong) YXInitRequest *request;
@property (nonatomic, strong) YXInitRequestItem *item;

@end

@interface YXInitHelper()
@property (nonatomic, strong) YXInitRequestItem_Body *body;
@end

@implementation YXInitHelper

- (void)dealloc
{
    [self.request stopRequest];
}

+ (instancetype)sharedHelper
{
    static YXInitHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
        [helper registerNotifications];
    });
    return helper;
}

- (void)requestCompeletion:(void(^)(void))completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXInitRequest alloc] init];
    [self.request startRequestWithRetClass:[YXInitRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
            self.item = retItem;
            [self saveAppleCheckingStatusToLocal];
            [self showUpgradeForInit:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:YXInitSuccessNotification object:nil];
        });
    }];
}

// 审核状态，默认返回YES
- (BOOL)isAppleChecking
{
    id isChecking = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAppleChecking"];
    if (isChecking) {
        return [isChecking boolValue];
    }
    return YES;
}

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willEnterForeground:(NSNotification *)notification
{
    [self showUpgradeForInit:NO];
}

- (void)showUpgradeForInit:(BOOL)isInit
{
    if (!self.item || self.item.data.count <= 0) {
        return;
    }

    self.body = self.item.data[0];

    if ([self.body isTest]) { //测试环境
#ifndef DEBUG
        return;
#endif
    }
    if (![self.body isForce] && !isInit) { //非强制升级只在初始化弹出一次
        return;
    }
    if (![self.body.fileURL yx_isHttpLink]) { //http链接
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.body.title message:self.body.content preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.body.fileURL]];
    }];
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    if (self.body.isForce) {
        [alert addAction:exitAction];
        [alert addAction:updateAction];
    }
    else {
        [alert addAction:laterAction];
        [alert addAction:updateAction];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
- (void)saveAppleCheckingStatusToLocal
{
    // 网络请求返回成功，isAppleChecking存在时保存到本地
    NSString *isAppleChecking = self.item.property.isAppleChecking;
    if ([isAppleChecking yx_isValidString]) {
        [[NSUserDefaults standardUserDefaults] setObject:isAppleChecking forKey:@"isAppleChecking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
