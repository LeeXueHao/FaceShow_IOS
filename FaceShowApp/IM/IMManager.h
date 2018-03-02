//
//  IMManager.h
//  TestIM
//
//  Created by niuzhaowang on 2017/12/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMember.h"

@interface IMManager : NSObject
+ (IMManager *)sharedInstance;

@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) IMMember *currentMember;

- (void)setupWithCurrentMember:(IMMember *)member token:(NSString *)token;

- (void)startConnection;
- (void)stopConnection;

@end
