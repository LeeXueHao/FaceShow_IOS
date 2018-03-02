//
//  IMServiceManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMServiceManager : NSObject
+ (IMServiceManager *)sharedInstance;

- (void)start;
- (void)stop;
@end
