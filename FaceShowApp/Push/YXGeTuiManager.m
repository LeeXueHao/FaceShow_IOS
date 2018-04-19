//
//  YXGeTuiManager.m
//  YanXiuStudentApp
//
//  Created by FanYu on 9/28/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXGeTuiManager.h"
#import "YXApnsContentModel.h"
#import <UserNotifications/UserNotifications.h>
#import "GeTuiConfig.h"

@interface YXGeTuiManager() <UIApplicationDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSString *currentUid;
@property (nonatomic, assign) BOOL sdkResumedMessage;
@property (nonatomic, assign) BOOL handleddByAPNS;

@end

@implementation YXGeTuiManager

+ (YXGeTuiManager *)sharedInstance {
    NSAssert([YXGeTuiManager class] == self, @"Incorrect use of singleton : %@, %@", [YXGeTuiManager class], [self class]);
    static YXGeTuiManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YXGeTuiManager alloc] init];
    });
    return sharedInstance;
}


#pragma mark - 注册
- (void)registerGeTuiWithDelegate:(id)delegate {
//    if ([UserManager sharedInstance].loginStatus)
    {
        
        self.sdkResumedMessage = NO;
        self.handleddByAPNS = NO;
        
        [GeTuiSdk runBackgroundEnable:YES];
        [GeTuiSdk startSdkWithAppId:kGeTuiAppID appKey:kGeTuiAppKey appSecret:kGeTuiAppSecret delegate:self];
        
        [self registerUserNotification];
    }
    
    self.delegate = delegate;
}

- (void)registerUserNotification {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 10.0){
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
    else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
}

- (void)registerDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DDLogError(@"[GTSdk DeviceToken]:%@", token);
    
    [GeTuiSdk registerDeviceToken:token];
}


#pragma mark - iOS10 Notification Delegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    UNNotification *notification = response.notification;
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    [self handleApnsContent:userInfo];
    completionHandler();
}


#pragma mark - login/out
- (void)loginSuccess {
    [self resumeGeTuiSDK];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    NSString *uid = [[UserManager sharedInstance] userModel].userID;
    self.currentUid = uid;
    
    self.sdkResumedMessage = YES;
    self.handleddByAPNS = NO;
    
    // 等待SDK启动时间 以及 防止5秒内连续退出登录
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self bindAlias:self.currentUid];
    });
}

- (void)logoutSuccess {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [self unbindAlias:self.currentUid];
}

- (void)resumeGeTuiSDK {
    
    [GeTuiSdk resume];
    
    [GeTuiSdk runBackgroundEnable:YES];
    
    [GeTuiSdk startSdkWithAppId:kGeTuiAppID appKey:kGeTuiAppKey appSecret:kGeTuiAppSecret delegate:self];
    
    [self registerUserNotification];
}


#pragma mark - Handle Notification
// 处理个推推送，App运行中
- (void)handleGeTuiContent:(id)content {
    NSError *error = nil;
    YXApnsContentModel *apns = nil;
    apns = [[YXApnsContentModel alloc] initWithString:content error:&error];
    NSLog(@"[Receive GeTui]:%@\n\n", content);
    
    SAFE_CALL_OneParam(self.delegate, handleApnsDataOnForeground, apns);  
}

// 处理来自苹果的推送 App后台或者杀死
-(void)handleApnsContent:(NSDictionary *)dict {
    [GeTuiSdk handleRemoteNotification:dict];
    
    self.handleddByAPNS = YES;
    
    YXApnsContentModel *apns = [[YXApnsContentModel alloc]initWithString:[dict valueForKey:@"payload"] error:nil];
    SAFE_CALL_OneParam(self.delegate, handleApnsData, apns);
}

-(void)scheduleLocalNotification:(NSDictionary *)userInfo {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertTitle = @"Title";
    notification.alertBody = @"body";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber += 1;
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - GeTuiSdkDelegate
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 个推消息数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    // 离线消息（App后台或杀死）个推服务器保存的消息
    if (offLine) {
        if ([[UserManager sharedInstance] loginStatus]) {
            if (self.sdkResumedMessage & !self.handleddByAPNS) {
                self.sdkResumedMessage = NO;
                self.handleddByAPNS = NO;
                [self handleGeTuiContent:payloadMsg];
            }
        }
    }
    // 在线消息（App正在使用中 个推直接推送的消息
    else {
        if ([[UserManager sharedInstance] loginStatus]) {
            [self handleGeTuiContent:payloadMsg];
        }
    }
    [self setBadge:0];
}

// SDK启动成功 则返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"[GTSdk RegisterClientID]:%@", clientId);
    
    NSString *uid = [[UserManager sharedInstance] userModel].userID;
    if (uid) {
        self.currentUid = uid;
        // 老用户更新App后 并且在已经登录状态下 进行绑定
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self bindAlias:uid];
            self.handleddByAPNS = NO;
        });
    }
}

// SDK遇到错误回调: 个推错误报告，集成步骤发生的任何错误都在这里通知
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@"[GTSdk error]:%@", [error localizedDescription]);
}

// SDK运行状态 0:正在启动 1:启动 2:停止
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    NSLog(@"[GTSdk SdkState]:%u", aStatus);
}

// SDK推送是否开启
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"[GTSdk SetModeOff Error]:%@", [error localizedDescription]);
        return;
    }
}

// SDK设置别名回调
- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    if ([kGtResponseBindType isEqualToString:action]) {
        if (isSuccess) {
            NSLog(@"[GTSdk 别名绑定结果]：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        } else {
            NSLog(@"[GTSdk 别名绑定失败]: %@", aError);
        }
    } else if ([kGtResponseUnBindType isEqualToString:action]) {
        if (isSuccess) {
            NSLog(@"[GTSdk 别名解绑结果]：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        } else {
            NSLog(@"[GTSdk 别名解绑失败]: %@", aError);
        }
        [GeTuiSdk destroy];
    }
}

#pragma mark - Private
- (void)setTagNames:(NSString *)tagNames {
    NSArray *names = [tagNames componentsSeparatedByString:@","];
    NSLog(@"[GTSdk 标签设置]：%@", ([GeTuiSdk setTags:names]) ? @"成功" : @"失败");
}

- (void)bindAlias:(NSString *)alias {
    [GeTuiSdk bindAlias:alias andSequenceNum:[NSString stringWithFormat:@"%@-sign", alias]];
}

- (void)unbindAlias:(NSString *)alias {
    [GeTuiSdk unbindAlias:alias andSequenceNum:[NSString stringWithFormat:@"%@-sign", alias]];
}

- (void)setBadge:(NSInteger)badgeNumber {
    [GeTuiSdk setBadge:badgeNumber];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}

- (void)resetBadge {
    [GeTuiSdk resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
