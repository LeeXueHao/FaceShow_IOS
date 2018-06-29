//
//  AppUseRecordManager.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddAppUseRecordRequest.h"

@interface AppUseRecordManager : NSObject
+ (AppUseRecordManager *)sharedInstance;

- (void)addRecord:(AddAppUseRecordRequest *)record;
@end
