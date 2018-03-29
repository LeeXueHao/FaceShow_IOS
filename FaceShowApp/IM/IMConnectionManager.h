//
//  IMConnectionManager.h
//  TestIM
//
//  Created by niuzhaowang on 2017/12/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSNotificationName const kIMConnectionDidCloseNotification;

@interface IMConnectionManager : NSObject

@property (nonatomic, assign, readonly) BOOL isConnectionOpen;

+ (IMConnectionManager *)sharedInstance;

- (void)connectWithHost:(NSString *)host
                   port:(NSUInteger)port
               username:(NSString *)username
               password:(NSString *)password;
- (void)disconnect;

- (void)subscribeTopic:(NSString *)topic;
- (void)unsubscribeTopic:(NSString *)topic;

@end
