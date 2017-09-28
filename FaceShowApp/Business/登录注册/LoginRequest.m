//
//  LoginRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequestItem
@end

@interface LoginRequest ()
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *appKey;
@end

@implementation LoginRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].loginServer;
        self.type = @"ALL";
        self.appKey = @"f749edf6-bc39-6ef9-8f81-158se5fds842";
    }
    return self;
}

@end
