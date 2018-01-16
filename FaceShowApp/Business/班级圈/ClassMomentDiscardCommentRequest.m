//
//  ClassMomentDiscardCommentRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentDiscardCommentRequest.h"

@implementation ClassMomentDiscardCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.discardComment";
    }
    return self;
}
@end
