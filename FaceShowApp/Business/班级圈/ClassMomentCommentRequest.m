//
//  ClassMomentCommentRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentCommentRequest.h"
@implementation ClassMomentCommentRequestItem

@end
@implementation ClassMomentCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.comment";
    }
    return self;
}

@end
