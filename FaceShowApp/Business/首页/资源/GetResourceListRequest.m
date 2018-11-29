//
//  GetResourceListRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetResourceListRequest.h"

@implementation GetResourceListRequestItem_resList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"reslistId"}];
}
@end

@implementation GetResourceListRequestItem_tagList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"taglistId"}];
}
@end

@implementation GetResourceListRequestItem_data
@end

@implementation GetResourceListRequestItem
@end

@implementation GetResourceListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.resource.list";
    }
    return self;
}
@end
