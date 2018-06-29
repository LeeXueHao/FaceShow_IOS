//
//  AddAppUseRecordRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AddAppUseRecordRequest.h"

@implementation AddAppUseRecordRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"operate.addRecord";
    }
    return self;
}
@end
