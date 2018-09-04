//
//  IMHeartbeatManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/9/4.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMHeartbeatManager.h"
#import "YXGCDTimer.h"
#import "IMOnlineHeartbeatRequest.h"

@interface IMHeartbeatManager ()
@property (nonatomic, strong) YXGCDTimer *timer;
@property (nonatomic, strong) IMOnlineHeartbeatRequest *heartbeatRequest;
@end

@implementation IMHeartbeatManager

+ (IMHeartbeatManager *)sharedInstance {
    static IMHeartbeatManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMHeartbeatManager alloc] init];
    });
    return manager;
}

- (void)performRequest {
    [self.heartbeatRequest stopRequest];
    self.heartbeatRequest = [[IMOnlineHeartbeatRequest alloc] init];
    [self.heartbeatRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            return;
        }
    }];
}

- (void)resumeHeartbeat {
    WEAK_SELF
    if (!self.timer) {
        self.timer = [[YXGCDTimer alloc] initWithInterval:60 repeats:YES triggerBlock:^{
            STRONG_SELF
            [self performRequest];
        }];
    }
    [self.timer resume];
}

- (void)suspendHeartbeat {
    [self.timer suspend];
}

@end
