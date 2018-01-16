//
//  ClassMomentDiscardRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentDiscardRequest.h"
@implementation ClassMomentDiscardItem

@end
@implementation ClassMomentDiscardRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.discardMoment";
    }
    return self;
}
@end
