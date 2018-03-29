//
//  IMOfflineMsgUpdateServiceManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMOfflineMsgUpdateServiceManager.h"

@interface IMOfflineMsgUpdateServiceManager()
@property (nonatomic, strong) NSMutableArray<IMOfflineMsgUpdateService *> *serviceArray;
@property (nonatomic, assign) BOOL isServiceRunning;
@end

@implementation IMOfflineMsgUpdateServiceManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serviceArray = [NSMutableArray array];
        self.isServiceRunning = NO;
    }
    return self;
}

- (void)addService:(IMOfflineMsgUpdateService *)service {
    [self.serviceArray addObject:service];
    [self checkAndUpdate];
}

- (void)checkAndUpdate{
    if (!self.isServiceRunning && self.serviceArray.count>0) {
        self.isServiceRunning = YES;
        IMOfflineMsgUpdateService *service = [self.serviceArray firstObject];
        WEAK_SELF
        [service startWithCompleteBlock:^(NSError *error) {
            STRONG_SELF
            [self.serviceArray removeObjectAtIndex:0];
            self.isServiceRunning = NO;
            [self checkAndUpdate];
        }];
    }
}

@end
