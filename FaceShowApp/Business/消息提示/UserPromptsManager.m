//
//  UserPromptsManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/12/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserPromptsManager.h"
#import "GCDTimer.h"
#import "GetUserPromptsRequest.h"

NSString * const kHasNewTaskNotification = @"kHasNewTaskNotification";
NSString * const kHasNewMomentNotification = @"kHasNewMomentNotification";
NSString * const kHasNewResourceNotification = @"kHasNewResourceNotification";

@interface UserPromptsManager ()
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, strong) GetUserPromptsRequest *promptRequest;
@end

@implementation UserPromptsManager

+ (UserPromptsManager *)sharedInstance {
    static UserPromptsManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserPromptsManager alloc] init];
    });
    return manager;
}

- (void)performRequest {
    [self.promptRequest stopRequest];
    self.promptRequest = [[GetUserPromptsRequest alloc] init];
    self.promptRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    self.promptRequest.bizIds = @"taskNew,momentNew,resourceNew";
    [self.promptRequest startRequestWithRetClass:[GetUserPromptsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            return;
        }
        GetUserPromptsRequestItem *item = (GetUserPromptsRequestItem *)retItem;
        self.taskNewView.hidden = item.data.taskNew.promptNum.integerValue==0;
        self.resourceNewView.hidden = item.data.resourceNew.promptNum.integerValue==0;
        self.momentNewView.hidden = item.data.momentNew.promptNum.integerValue==0;
        if (item.data.taskNew.promptNum.integerValue > 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kHasNewTaskNotification object:nil];
        }
        if (item.data.resourceNew.promptNum.integerValue > 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kHasNewResourceNotification object:nil];
        }
        if (item.data.momentNew.promptNum.integerValue > 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kHasNewMomentNotification object:nil];
        }
    }];
}

- (void)resumeHeartbeat {
    WEAK_SELF
    if (!self.timer) {
        self.timer = [[GCDTimer alloc] initWithInterval:30 repeats:YES triggerBlock:^{
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
