//
//  ClassMomentClickLikeRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentClickLikeRequest.h"
@implementation ClassMomentClickLikeRequestItem
@end
@implementation ClassMomentClickLikeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.like";
    }
    return self;
}
@end
