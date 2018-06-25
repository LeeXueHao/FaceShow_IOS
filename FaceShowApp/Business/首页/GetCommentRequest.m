//
//  GetCommentRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetCommentRequest.h"

@implementation GetCommentRequestItem_data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end

@implementation GetCommentRequestItem

@end

@implementation GetCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.getComment";
    }
    return self;
}
@end
