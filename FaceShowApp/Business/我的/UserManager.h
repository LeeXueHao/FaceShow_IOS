//
//  UserManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "GetClassConfigRequest.h"

extern NSString * const kUserDidLoginNotification;
extern NSString * const kUserDidLogoutNotification;

@interface UserManager : NSObject

+ (UserManager *)sharedInstance;

@property (nonatomic, strong) NSArray *stages;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) GetClassConfigRequest_Item *configItem;
@property (nonatomic, assign) BOOL loginStatus;
@property (nonatomic, assign) BOOL hasUsedBefore;
- (void)saveData ;

@end
