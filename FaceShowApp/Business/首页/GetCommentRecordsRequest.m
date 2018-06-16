//
//  GetCommentRecordsRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetCommentRecordsRequest.h"
@implementation GetCommentRecordsRequestItem_element
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation GetCommentRecordsRequestItem_data

@end

@implementation GetCommentRecordsRequestItem

@end

@implementation GetCommentRecordsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.commentRecords";
    }
    return self;
}
@end
