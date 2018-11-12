//
//  NBGetResourceListRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBGetResourceListRequest.h"

@implementation NBGetResourceListRequestItem_resList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"reslistId"}];
}
@end

@implementation NBGetResourceListRequestItem_tagList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"taglistId"}];
}
@end

@implementation NBGetResourceListRequestItem_data
@end

@implementation NBGetResourceListRequestItem
@end

@implementation NBGetResourceListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.resource.list";
    }
    return self;
}
@end
