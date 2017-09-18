//
//  UserManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserManager.h"

NSString * const kUserDidLoginNotification = @"kUserDidLoginNotification";
NSString * const kUserDidLogoutNotification = @"kUserDidLogoutNotification";

@implementation UserManager
@synthesize loginStatus = _loginStatus;

+ (UserManager *)sharedInstance {
    static dispatch_once_t once;
    static UserManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[UserManager alloc] init];
        [sharedInstance loadData];
    });
    
    return sharedInstance;
}

- (void)setLoginStatus:(BOOL)loginStatus {
    if (loginStatus) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserDidLoginNotification object:nil];
    }else {
        self.userModel = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserDidLogoutNotification object:nil];
    }
}

- (BOOL)loginStatus {
    if (self.userModel) {
        return YES;
    }
    return NO;
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [self saveData];
}

#pragma mark - 
- (void)saveData {
    NSString *json = [self.userModel toJSONString];
    [[NSUserDefaults standardUserDefaults]setValue:json forKey:@"user_model_key"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)loadData {
    NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_model_key"];
    if (json) {
        self.userModel = [[UserModel alloc]initWithString:json error:nil];
    }
}

@end
