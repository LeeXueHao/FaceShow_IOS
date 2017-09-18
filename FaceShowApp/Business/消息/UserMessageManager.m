//
//  UserMessageManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserMessageManager.h"
#import "GCDTimer.h"

@interface UserMessageManager ()

@property (nonatomic, strong) GCDTimer *timer;

@end

@implementation UserMessageManager

+ (UserMessageManager *)sharedInstance {
    static UserMessageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserMessageManager alloc] init];
    });
    return manager;
}

- (void)fetchUserMessage {
    DDLogDebug(@"heartbeat!");
}

- (void)resumeHeartbeat {
    WEAK_SELF
    self.timer = [[GCDTimer alloc] initWithInterval:5 repeats:YES triggerBlock:^{
        STRONG_SELF
        [self fetchUserMessage];
    }];
    [self.timer resume];
}

- (void)suspendHeartbeat {
    [self.timer suspend];
}

@end
