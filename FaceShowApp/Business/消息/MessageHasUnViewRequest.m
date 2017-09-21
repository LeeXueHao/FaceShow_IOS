//
//  MessageHasUnViewRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MessageHasUnViewRequest.h"

@implementation MessageHasUnViewRequestItem_Data
@end

@implementation MessageHasUnViewRequestItem
@end

@implementation MessageHasUnViewRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"notice.hasUnView";
    }
    return self;
}
@end
