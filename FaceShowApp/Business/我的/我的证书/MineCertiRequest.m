//
//  MineCertiRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MineCertiRequest.h"

@implementation MineCertiRequest_Item_userCertList
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"certId"}];
}
@end

@implementation MineCertiRequest_Item_clazsCertList
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"clazsCertid",@"description":@"listDescription"}];
}
@end

@implementation MineCertiRequest_Item_data
@end

@implementation MineCertiRequest_Item
@end

@implementation MineCertiRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.cert.myCerts";
    }
    return self;
}
@end
