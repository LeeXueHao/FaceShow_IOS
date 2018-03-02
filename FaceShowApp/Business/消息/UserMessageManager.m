//
//  UserMessageManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserMessageManager.h"
#import "YXGCDTimer.h"
#import "MessageHasUnViewRequest.h"

NSString * const kHasNewMessageNotification = @"kHasNewMessageNotification";

@interface UserMessageManager ()
@property (nonatomic, strong) YXGCDTimer *timer;
@property (nonatomic, strong) MessageHasUnViewRequest *messageHasUnViewRequest;
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

- (void)fetchUserMessageWithNeedRefreshList:(BOOL)needRefresh {
    [self.messageHasUnViewRequest stopRequest];
    self.messageHasUnViewRequest = [[MessageHasUnViewRequest alloc] init];
    self.messageHasUnViewRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    [self.messageHasUnViewRequest startRequestWithRetClass:[MessageHasUnViewRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            return;
        }
        MessageHasUnViewRequestItem *item = (MessageHasUnViewRequestItem *)retItem;
        if (item.data.hasUnView && needRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kHasNewMessageNotification object:nil];
        }
        self.redPointView.hidden = !item.data.hasUnView;
    }];
}

- (void)resumeHeartbeat {
    WEAK_SELF
    if (!self.timer) {
        self.timer = [[YXGCDTimer alloc] initWithInterval:30 repeats:YES triggerBlock:^{
            STRONG_SELF
            [self fetchUserMessageWithNeedRefreshList:YES];
        }];
    }
    [self.timer resume];
}

- (void)suspendHeartbeat {
    [self.timer suspend];
}

@end
