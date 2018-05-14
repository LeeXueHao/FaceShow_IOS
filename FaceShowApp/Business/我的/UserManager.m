//
//  UserManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserManager.h"
#import "StageSubjectItem.h"

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
    if (self.userModel.token && self.userModel.imInfo.imToken) {
        return YES;
    }
    return NO;
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [self saveData];
}

- (void)setHasUsedBefore:(BOOL)hasUsedBefore {
    [[NSUserDefaults standardUserDefaults]setBool:hasUsedBefore forKey:self.userModel.userID];
}

- (BOOL)hasUsedBefore {
    return [[NSUserDefaults standardUserDefaults]boolForKey:self.userModel.userID];
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
    NSData *stageSubjectData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StageSubject" ofType:@"json"]];
    if (stageSubjectData) {
        StageSubjectItem *item = [[StageSubjectItem alloc] initWithData:stageSubjectData error:NULL];
        self.stages = item.data;
    }
}

@end
