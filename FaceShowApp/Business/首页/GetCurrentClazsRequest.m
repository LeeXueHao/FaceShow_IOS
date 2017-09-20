//
//  GetCurrentClazsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetCurrentClazsRequest.h"

@implementation GetCurrentClazsRequestItem_projectManagerInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"managerId"}];
}
@end

@implementation GetCurrentClazsRequestItem_projectInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"projectId",@"description":@"desc"}];
}
@end

@implementation GetCurrentClazsRequestItem_clazsInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"clazsId",@"description":@"desc"}];
}
@end

@implementation GetCurrentClazsRequestItem_data

@end

@implementation GetCurrentClazsRequestItem

@end

@implementation GetCurrentClazsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.getCurrentClazs";
    }
    return self;
}
@end
