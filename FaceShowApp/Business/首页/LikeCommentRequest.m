//
//  LikeCommentRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LikeCommentRequest.h"

@implementation LikeCommentRequestItem_data

@end

@implementation LikeCommentRequestItem

@end

@implementation LikeCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.likeCommentRecord";
    }
    return self;
}
@end
