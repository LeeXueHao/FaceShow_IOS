//
//  PositionSignInRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PositionSignInRequest.h"

@implementation PositionSignInRequestItem_data
@end

@implementation PositionSignInRequestItem
@end

@implementation PositionSignInRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.positionSignins";
    }
    return self;
}
@end
