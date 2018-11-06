//
//  LoginDataManager.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AppLoginType) {
    AppLoginType_AccountLogin,
    AppLoginType_AppCodeLogin
};

@interface LoginDataManager : NSObject

+ (void)loginWithName:(NSString *)name password:(NSString *)password loginType:(AppLoginType)type completeBlock:(void(^)(NSError *error))completeBlock;

//+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void(^)(NSError *error))completeBlock;
//
//+ (void)loginWithName:(NSString *)name verifyCode:(NSString *)verifyCode completeBlock:(void(^)(NSError *error))completeBlock;
@end
