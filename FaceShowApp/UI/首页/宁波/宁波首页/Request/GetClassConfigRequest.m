//
//  GetClassConfigRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetClassConfigRequest.h"

@implementation GetClassConfigRequest_Item_tabConf
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"tabConfId"}];
}
@end

@implementation GetClassConfigRequest_Item_pageConf
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"pageConfId"}];
}
@end

@implementation GetClassConfigRequest_Item_pageList
@end

@implementation GetClassConfigRequest_Item_data
@end

@implementation GetClassConfigRequest_Item
@end

@implementation GetClassConfigRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"clazs.getConf";
    }
    return self;
}
@end
