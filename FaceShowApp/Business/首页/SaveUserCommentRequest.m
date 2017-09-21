//
//  SaveUserCommentRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SaveUserCommentRequest.h"

@implementation SaveUserCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.saveUserComment";
    }
    return self;
}
@end
