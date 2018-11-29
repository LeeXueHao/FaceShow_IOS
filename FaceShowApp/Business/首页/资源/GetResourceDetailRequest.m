//
//  GetResourceDetailRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetResourceDetailRequest.h"

@implementation GetResourceDetailRequestItem_Data_Ai
@end

@implementation GetResourceDetailRequestItem_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"resourceId"}];
}
@end

@implementation GetResourceDetailRequestItem
@end

@implementation GetResourceDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"resource.view";
    }
    return self;
}
@end
