//
//  YXGeTuiManager.h
//  YanXiuStudentApp
//
//  Created by FanYu on 9/28/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"
#import "YXApnsContentModel.h"

@protocol YXApnsDelegate <NSObject>
- (void)handleApnsData:(YXApnsContentModel *)apns;
- (void)handleApnsDataOnForeground:(YXApnsContentModel *)apns;
@end

@interface YXGeTuiManager : NSObject <GeTuiSdkDelegate>

@property (nonatomic, weak) id<YXApnsDelegate> delegate;

+ (YXGeTuiManager *)sharedInstance;

- (void)loginSuccess;
- (void)logoutSuccess;
- (void)handleApnsContent:(NSDictionary *)dict;
- (void)registerGeTuiWithDelegate:(id)delegate;
- (void)registerDeviceToken:(NSData *)deviceToken;

@end
