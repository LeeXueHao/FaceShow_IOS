//
//  UserPromptsManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/12/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHasNewTaskNotification;
extern NSString * const kHasNewMomentNotification;
extern NSString * const kHasNewResourceNotification;

@interface UserPromptsManager : NSObject
@property (nonatomic, strong) UIView *taskNewView;
@property (nonatomic, strong) UIView *resourceNewView;
@property (nonatomic, strong) UIView *momentNewView;

+ (UserPromptsManager *)sharedInstance;

- (void)resumeHeartbeat;
- (void)suspendHeartbeat;
@end
