//
//  ClassMomentPublishRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentPublishRequest.h"
@implementation ClassMomentPublishRequestItem

@end
@implementation ClassMomentPublishRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.publishMoment";
    }
    return self;
}
@end
