//
//  ClassMomentReplyRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentReplyRequest.h"
@implementation ClassMomentReplyItem
@end
@implementation ClassMomentReplyRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.reply";
    }
    return self;
}
@end
