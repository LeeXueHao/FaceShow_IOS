//
//  GetResourceRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetResourceRequest.h"

@implementation GetResourceRequestItem_Element
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"elementId"}];
}
@end

@implementation GetResourceRequestItem_Data
@end

@implementation GetResourceRequestItem
@end

@implementation GetResourceRequest
- (instancetype)init {
    if (self = [super init]) {
        self.offset = @"0";
        self.pageSize = @"10000";
        self.method = @"resource.list";
    }
    return self;
}
@end
