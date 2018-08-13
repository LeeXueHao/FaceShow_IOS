//
//  BasicDataRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BasicDataRequest.h"
#import "BasicDataConfig.h"

@implementation BasicDataRequestItem_data

@end

@implementation BasicDataRequestItem

@end



@implementation BasicDataRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kBasicDataServer;
        self.method = @"basicdata.config";
    }
    return self;
}
@end
