//
//  AppUseRecordManager.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AppUseRecordManager.h"

@interface AppUseRecordManager()
@property (nonatomic, strong) NSMutableArray *recordArray;
@property (nonatomic, assign) BOOL isRecordSending;
@end

@implementation AppUseRecordManager
+ (AppUseRecordManager *)sharedInstance {
    static AppUseRecordManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppUseRecordManager alloc] init];
        manager.recordArray = [NSMutableArray array];
        manager.isRecordSending = NO;
    });
    return manager;
}

- (void)addRecord:(AddAppUseRecordRequest *)record {
    [self.recordArray addObject:record];
    [self checkAndUpdate];
}

- (void)checkAndUpdate{
    if (!self.isRecordSending && self.recordArray.count>0) {
        self.isRecordSending = YES;
        AddAppUseRecordRequest *request = [self.recordArray firstObject];
        WEAK_SELF
        [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.recordArray removeObjectAtIndex:0];
            self.isRecordSending = NO;
            [self checkAndUpdate];
        }];
    }
}

@end
