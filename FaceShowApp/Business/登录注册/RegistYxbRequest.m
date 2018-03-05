//
//  RegistYxbRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "RegistYxbRequest.h"

@implementation RegistYxbRequestItem_clazsInfo
@end

@implementation RegistYxbRequestItem_data
@end

@implementation RegistYxbRequestItem
@end

@implementation RegistYxbRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.registYxb";
    }
    return self;
}
@end
