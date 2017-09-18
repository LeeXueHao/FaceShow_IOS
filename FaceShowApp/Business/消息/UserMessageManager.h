//
//  UserMessageManager.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMessageManager : NSObject

+ (UserMessageManager *)sharedInstance;

- (void)fetchUserMessage;

- (void)resumeHeartbeat;
- (void)suspendHeartbeat;

@end
