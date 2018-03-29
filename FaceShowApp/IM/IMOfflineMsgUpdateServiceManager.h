//
//  IMOfflineMsgUpdateServiceManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMOfflineMsgUpdateService.h"

@interface IMOfflineMsgUpdateServiceManager : NSObject
- (void)addService:(IMOfflineMsgUpdateService *)service;
@end
