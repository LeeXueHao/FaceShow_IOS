//
//  AppDelegate.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegateHelper.h"
#import "UserMessageManager.h"
#import "YXGeTuiManager.h"
#import <BMKLocationKit/BMKLocationAuth.h>
#import "UserPromptsManager.h"
#import "YXInitRequest.h"
#import "IMManager.h"
#import "IMUserInterface.h"
#import "TalkingDataConfig.h"
#import "BMKLocationConfig.h"
#import "AppUseRecordManager.h"
#import "BasicDataManager.h"

@interface AppDelegate ()<BMKLocationAuthDelegate>
@property (nonatomic, strong) AppDelegateHelper *appDelegateHelper;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GlobalUtils setupCore];
    // Talking Data统计
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
    [TalkingData sessionStarted:kTalkingDataAppKey withChannelId:kTalkingDataChannel];
    // 初始化请求，检测版本更新等
    [[YXInitHelper sharedHelper] requestCompeletion:nil];
    // 检查基础数据更新
    [[BasicDataManager sharedInstance]checkAndUpdataBasicData];
    
    [[YXGeTuiManager sharedInstance] registerGeTuiWithDelegate:self];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:kBMKLocationKey authDelegate:self];
    [self registerNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];

    NSString *key = [NSString stringWithFormat:@"v%@_user_need_login",[ConfigManager sharedInstance].clientVersion];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key]){
        [UserManager sharedInstance].loginStatus = NO;
    }

    if ([UserManager sharedInstance].loginStatus) {
        [[UserMessageManager sharedInstance] resumeHeartbeat];
        [[UserPromptsManager sharedInstance] resumeHeartbeat];
        [[IMManager sharedInstance]setupWithCurrentMember:[[UserManager sharedInstance].userModel.imInfo.imMember toIMMember] token:[UserManager sharedInstance].userModel.imInfo.imToken];
        [[IMManager sharedInstance]setupWithSceneID:[UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId];
        [[IMManager sharedInstance] startConnection];
        //使用情况统计
        AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
        request.actionType = AppUseRecordActionType_AutoLogin;
        [[AppUseRecordManager sharedInstance]addRecord:request];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.appDelegateHelper = [[AppDelegateHelper alloc]initWithWindow:self.window];
    self.window.rootViewController = [self.appDelegateHelper rootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerNotifications {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLoginNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXGeTuiManager sharedInstance] loginSuccess];
        [[UserMessageManager sharedInstance] resumeHeartbeat];
        [[UserPromptsManager sharedInstance] resumeHeartbeat];
        [[IMManager sharedInstance]setupWithCurrentMember:[[UserManager sharedInstance].userModel.imInfo.imMember toIMMember] token:[UserManager sharedInstance].userModel.imInfo.imToken];
        [[IMManager sharedInstance]setupWithSceneID:[UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId];
        [[IMManager sharedInstance] startConnection];
        [self.appDelegateHelper handleLoginSuccess];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLogoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXGeTuiManager sharedInstance] logoutSuccess];
        [self.appDelegateHelper handleLogoutSuccess];
        [[UserMessageManager sharedInstance] suspendHeartbeat];
        [[UserPromptsManager sharedInstance] suspendHeartbeat];
        [[IMManager sharedInstance] stopConnection];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kClassDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.appDelegateHelper handleClassChange];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kIMTopicDidRemoveNotification object:nil] subscribeNext:^(id x) {
       STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        IMTopic *topic = noti.object;
        [self.appDelegateHelper handleRemoveFromOneClass:topic];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([UserManager sharedInstance].loginStatus) {
        [[IMManager sharedInstance]stopConnection];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([UserManager sharedInstance].loginStatus) {
        [[IMManager sharedInstance]startConnection];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[IMManager sharedInstance] stopConnection];
    [GlobalUtils clearCore];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk resume]; // 后台恢复SDK 运行
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YXGeTuiManager sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    DDLogError(@"%@",[NSString stringWithFormat: @"Error: %@",err]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    //iOS10 之前的 暂不处理, 否则会与 YXGeTuiManager 中的 注册通知代理方法 重叠
    if (@available(iOS 10.0, *)) {

    }else{
        [[YXGeTuiManager sharedInstance] handleApnsContent:userInfo];
    }
    application.applicationIconBadgeNumber -= 1;
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self.appDelegateHelper handleOpenUrl:url];
    return YES;
}

#pragma mark - Apns Delegate
- (void)handleApnsData:(YXApnsContentModel *)apns {
    [self.appDelegateHelper handleApnsData:apns];
}

- (void)handleApnsDataOnForeground:(YXApnsContentModel *)apns {
    [self.appDelegateHelper handleApnsDataOnForeground:apns];
}

#pragma mark - BMKLocationAuthDelegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    if (iError != BMKLocationAuthErrorSuccess) {
        NSLog(@"BaiduLoc鉴权失败 errorCode: %ld", (long)iError);
    }
}

@end
