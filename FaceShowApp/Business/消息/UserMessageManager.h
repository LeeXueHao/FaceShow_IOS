//
//  UserMessageManager.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern  NSString * const kHasNewMessageNotification;

@interface UserMessageManager : NSObject

@property (nonatomic, strong) UIView *redPointView;

+ (UserMessageManager *)sharedInstance;

- (void)fetchUserMessageWithNeedRefreshList:(BOOL)needRefresh;

- (void)resumeHeartbeat;
- (void)suspendHeartbeat;

@end
