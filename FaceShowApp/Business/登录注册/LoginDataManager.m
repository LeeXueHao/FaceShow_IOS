//
//  LoginDataManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginDataManager.h"
#import "LoginRequest.h"
#import "AppCodeLoginRequest.h"
#import "GetCurrentClazsRequest.h"
#import "GetUserInfoRequest.h"
#import "AppUseRecordManager.h"
#import "GetClassConfigRequest.h"

@interface LoginDataManager()
@property (nonatomic, strong) GetCurrentClazsRequest *getClassRequest;
@property (nonatomic, strong) GetUserInfoRequest *getUserInfoRequest;
@property (nonatomic, copy) void(^loginBlock)(NSError *error);
@property (nonatomic, strong) YXGetRequest *loginBaseRequest;
@property (nonatomic, strong) GetClassConfigRequest *getClassConfigRequest;
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

+ (void)loginWithName:(NSString *)name password:(NSString *)password loginType:(AppLoginType)type completeBlock:(void(^)(NSError *error))completeBlock{
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.loginBaseRequest stopRequest];
    manager.loginBaseRequest = [manager getRequestWithName:name password:password LoginType:type];
    WEAK_SELF
    [manager.loginBaseRequest startRequestWithRetClass:[LoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock, error);
            return;
        }
        LoginRequestItem *item = (LoginRequestItem *)retItem;
        UserModel *userModel = [[UserModel alloc] init];
        userModel.token = item.token;
        userModel.passport = item.passport;
        manager.loginBlock = completeBlock;
        [manager fetchClazsRequestWithUserModel:userModel];
    }];

}

- (YXGetRequest *)getRequestWithName:(NSString *)name password:(NSString *)password LoginType:(AppLoginType)type{
    switch (type) {
        case AppLoginType_AccountLogin:
        {
            LoginRequest *loginRequest = [[LoginRequest alloc]init];
            loginRequest.loginName = name;
            loginRequest.password = [password md5];
            return loginRequest;
        }
        case AppLoginType_AppCodeLogin:
        {
            AppCodeLoginRequest *appCodeLoginRequest = [[AppCodeLoginRequest alloc] init];
            appCodeLoginRequest.mobile = name;
            appCodeLoginRequest.code = password;
            return appCodeLoginRequest;
        }
        default:
            return nil;
    }
}

- (void)fetchClazsRequestWithUserModel:(UserModel *)userModel{

    [self.getClassRequest stopRequest];
    self.getClassRequest = [[GetCurrentClazsRequest alloc] init];
    self.getClassRequest.token = userModel.token;
    [self.getClassRequest startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            BLOCK_EXEC(self.loginBlock, error);
            return;
        }

        GetCurrentClazsRequestItem *item = (GetCurrentClazsRequestItem *)retItem;
        if (!item.data.projectInfo) {
            NSError *emptyError = [NSError errorWithDomain:@"班级为空" code:10086 userInfo:nil];
            BLOCK_EXEC(self.loginBlock, emptyError);
            return;
        }
        userModel.projectClassInfo = item;

        if([item.data.clazsInfo.modelId isEqualToString:@"0"]){
            [UserManager sharedInstance].configItem = nil;
            [self.getUserInfoRequest stopRequest];
            self.getUserInfoRequest = [[GetUserInfoRequest alloc] init];
            self.getUserInfoRequest.token = userModel.token;
            WEAK_SELF
            [self.getUserInfoRequest startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                STRONG_SELF
                if (error) {
                    BLOCK_EXEC(self.loginBlock, error);
                    return;
                }
                GetUserInfoRequestItem *userInfo = (GetUserInfoRequestItem *)retItem;
                [UserManager sharedInstance].userModel = userModel;
                [[UserManager sharedInstance].userModel updateFromUserInfo:userInfo.data];
                [[UserManager sharedInstance] saveData];
                //使用情况统计
                AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
                request.actionType = AppUseRecordActionType_AccountLogin;
                [[AppUseRecordManager sharedInstance]addRecord:request];
                BLOCK_EXEC(self.loginBlock, nil);
            }];
        }else{
            [self.getClassConfigRequest stopRequest];
            self.getClassConfigRequest = [[GetClassConfigRequest alloc] init];
            self.getClassConfigRequest.modleId = item.data.clazsInfo.modelId;
            WEAK_SELF
            [self.getClassConfigRequest startRequestWithRetClass:[GetClassConfigRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                STRONG_SELF
                [UserManager sharedInstance].configItem = (GetClassConfigRequest_Item *)retItem;
                [self.getUserInfoRequest stopRequest];
                self.getUserInfoRequest = [[GetUserInfoRequest alloc] init];
                self.getUserInfoRequest.token = userModel.token;
                WEAK_SELF
                [self.getUserInfoRequest startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                    STRONG_SELF
                    if (error) {
                        BLOCK_EXEC(self.loginBlock, error);
                        return;
                    }
                    GetUserInfoRequestItem *userInfo = (GetUserInfoRequestItem *)retItem;
                    [UserManager sharedInstance].userModel = userModel;
                    [[UserManager sharedInstance].userModel updateFromUserInfo:userInfo.data];
                    [[UserManager sharedInstance] saveData];
                    //使用情况统计
                    AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
                    request.actionType = AppUseRecordActionType_AccountLogin;
                    [[AppUseRecordManager sharedInstance]addRecord:request];
                    BLOCK_EXEC(self.loginBlock, nil);
                }];
            }];
        }
    }];
}

@end

