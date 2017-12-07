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
#import "UserSignInRequest.h"
#import "ScanCodeResultViewController.h"

@interface AppDelegate ()<BMKLocationAuthDelegate>
@property (nonatomic, strong) AppDelegateHelper *appDelegateHelper;
@property (nonatomic, strong) UserSignInRequest *request;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GlobalUtils setupCore];
    [[YXGeTuiManager sharedInstance] registerGeTuiWithDelegate:self];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:[ConfigManager sharedInstance].BaiduLocAppKey authDelegate:self];
    [self registerNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    if ([UserManager sharedInstance].loginStatus) {
        [[UserMessageManager sharedInstance] resumeHeartbeat];
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
        [self.appDelegateHelper handleLoginSuccess];
        [[UserMessageManager sharedInstance] resumeHeartbeat];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLogoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXGeTuiManager sharedInstance] logoutSuccess];
        [self.appDelegateHelper handleLogoutSuccess];
        [[UserMessageManager sharedInstance] suspendHeartbeat];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
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
    [[YXGeTuiManager sharedInstance] handleApnsContent:userInfo];
    application.applicationIconBadgeNumber -= 1;
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [self.window nyx_startLoading];
    self.request = [[UserSignInRequest alloc] init];
    self.request.stepId = @"";
    //    if ([stringValue containsString:@"timestamp="]) {
    //        NSString *timestamp = array[1];
    //        self.request.timestamp = [timestamp substringFromIndex:10];
    //    }
    WEAK_SELF
    [self.request startRequestWithRetClass:[UserSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.window nyx_stopLoading];
        if (error && error.code == 1) {
            [self.window nyx_showToast:error.localizedDescription];
            return;
        }
        UserSignInRequestItem *item = (UserSignInRequestItem *)retItem;
        ScanCodeResultViewController *scanCodeResultVC = [[ScanCodeResultViewController alloc] init];
        scanCodeResultVC.data = error ? nil : item.data;
        scanCodeResultVC.error = error ? item.error : nil;
        FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:scanCodeResultVC];
        [scanCodeResultVC nyx_setupLeftWithImageName:@"返回页面按钮正常态-" highlightImageName:@"返回页面按钮点击态" action:^{
            [scanCodeResultVC dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }];
    
    return YES;
}

#pragma mark - Apns Delegate
- (void)handleApnsData:(YXApnsContentModel *)apns {
    [self.appDelegateHelper handleApnsData:apns];
}

#pragma mark - BMKLocationAuthDelegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    if (iError != BMKLocationAuthErrorSuccess) {
        NSLog(@"BaiduLoc鉴权失败 errorCode: %ld", (long)iError);
    }
}

@end
