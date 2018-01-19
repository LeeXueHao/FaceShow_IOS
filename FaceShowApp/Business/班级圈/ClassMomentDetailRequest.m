//
//  ClassMomentDetailRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentDetailRequest.h"
@implementation ClassMomentDetailItem
@end
@implementation ClassMomentDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.getMoment";
    }
    return self;
}
@end
