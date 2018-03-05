//
//  GetCheckCodeRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetCheckCodeRequest.h"

@implementation GetCheckCodeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.getCheckCode";
    }
    return self;
}
@end
