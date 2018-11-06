//
//  AppCodeLoginRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AppCodeLoginRequest.h"

@implementation AppCodeLoginRequestItem
@end

@interface AppCodeLoginRequest ()
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *appKey;
@end

@implementation AppCodeLoginRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].quickLoginServer;
        self.type = @"ALL";
        self.appKey = @"f749edf6-bc39-6ef9-8f81-158se5fds842";
    }
    return self;
}

@end
