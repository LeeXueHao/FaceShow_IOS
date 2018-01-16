//
//  ClassMomentCancelLikeRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentCancelLikeRequest.h"

@implementation ClassMomentCancelLikeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.cancelLike";
    }
    return self;
}
@end
