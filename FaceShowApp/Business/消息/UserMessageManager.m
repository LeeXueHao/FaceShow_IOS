//
//  UserMessageManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserMessageManager.h"
#import "GCDTimer.h"
#import "MessageHasUnViewRequest.h"

@interface UserMessageManager ()
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, strong) MessageHasUnViewRequest *messageHasUnViewRequest;
@property (nonatomic, assign) int num;
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
    [self.messageHasUnViewRequest stopRequest];
    self.messageHasUnViewRequest = [[MessageHasUnViewRequest alloc] init];
    [self.messageHasUnViewRequest startRequestWithRetClass:[MessageHasUnViewRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            return;
        }
        MessageHasUnViewRequestItem *item = (MessageHasUnViewRequestItem *)retItem;
        self.messageItem.badgeValue = item.data.hasUnView ? @"" : nil;
    }];
}

- (void)resumeHeartbeat {
    WEAK_SELF
    self.timer = [[GCDTimer alloc] initWithInterval:30 repeats:YES triggerBlock:^{
        STRONG_SELF
        [self fetchUserMessage];
    }];
//    [self.timer resume];
}

- (void)suspendHeartbeat {
    [self.timer suspend];
}

@end
