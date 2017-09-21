//
//  LoginDataManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginDataManager.h"
#import "LoginRequest.h"

@interface LoginDataManager()
@property (nonatomic, strong) LoginRequest *loginRequest;
@end

@implementation LoginDataManager

+ (LoginDataManager *)sharedInstance {
    static LoginDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LoginDataManager new];
    });
    return manager;
}

+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void (^)(NSError *))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.loginRequest stopRequest];
    manager.loginRequest = [[LoginRequest alloc]init];
    manager.loginRequest.loginName = name;
    manager.loginRequest.password = [password md5];
    WEAK_SELF
    [manager.loginRequest startRequestWithRetClass:[LoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        LoginRequestItem *item = (LoginRequestItem *)retItem;
        [UserManager sharedInstance].userModel.token = item.token;
        [UserManager sharedInstance].loginStatus = YES;
        BLOCK_EXEC(completeBlock, nil);
    }];
}

@end
