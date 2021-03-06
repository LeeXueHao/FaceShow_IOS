//
//  LoginUtils.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "LoginUtils.h"

@implementation LoginUtils

+ (void)verifyMobileLength:(NSString *)mobileNumber completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = YES;
    if (![mobileNumber yx_isValidString]) {
        isEmpty = YES;
    }
    if (mobileNumber.length < 11) {
        formatIsCorrect = NO;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

+ (void)verifyMobileNumberFormat:(NSString *)mobileNumber completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = YES;
    if (![mobileNumber yx_isValidString]) {
        isEmpty = YES;
    }
    if (![mobileNumber yx_isPhoneNum]) {
        formatIsCorrect = NO;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

+ (void)verifyAccountID:(NSString *)accountID completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = YES;
    if (![accountID yx_isValidString]) {
        isEmpty = YES;
    }
    if (accountID.length < 11 || accountID.length > 16) {
        formatIsCorrect = NO;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

+ (void)verifyPasswordFormat:(NSString *)password completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = YES;
    if (![password yx_isValidString]) {
        isEmpty = YES;
    }
    if (password.length < 6 || password.length > 18) {
        formatIsCorrect = NO;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

+ (void)verifySMSCodeFormat:(NSString *)SMSCode completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = NO;
    if (![SMSCode yx_isValidString]) {
        isEmpty = YES;
    }
    if (SMSCode.length == 4) {
        formatIsCorrect = YES;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

#pragma mark - new
+ (BOOL)isAccountValid:(NSString *)account {
    return account.length>=11 && account.length<=16;
}

+ (BOOL)isPasswordValid:(NSString *)password {
    return password.length>=6 && password.length<=20;
}

+ (BOOL)isPhoneNumberValid:(NSString *)phone {
    return [phone yx_isPhoneNum];
}

+ (BOOL)isVerifyCodeValid:(NSString *)code {
    return code.length==4;
}

+ (BOOL)isNameValid:(NSString *)name {
    return name.length<=6 && name.length>0;
}

+ (BOOL)hasEmpty:(NSString *)password{
    NSRange range = [password rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}
@end
