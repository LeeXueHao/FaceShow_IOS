//
//  NBGetResourceListRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBGetResourceListRequest.h"

@implementation NBGetResourceListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.courses";
    }
    return self;
}
@end
