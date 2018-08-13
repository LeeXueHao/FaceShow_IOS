//
//  BasicDataManager.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicDataManager : NSObject
+ (BasicDataManager *)sharedInstance;
- (void)checkAndUpdataBasicData;
@end
