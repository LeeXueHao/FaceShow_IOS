//
//  IMHeartbeatManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/9/4.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMHeartbeatManager : NSObject
+ (IMHeartbeatManager *)sharedInstance;

- (void)resumeHeartbeat;
- (void)suspendHeartbeat;
@end
