//
//  GetClazsSocresRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetClazsSocresRequest.h"

@implementation GetClazsSocresRequestItem_element
@end

@implementation GetClazsSocresRequestItem_clazsUserScore
@end

@implementation GetClazsSocresRequestItem_data
@end

@implementation GetClazsSocresRequestItem
@end

@implementation GetClazsSocresRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"clazs.clazsScores";
    }
    return self;
}
@end
