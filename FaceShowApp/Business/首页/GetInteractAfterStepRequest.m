//
//  GetInteractAfterStepRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetInteractAfterStepRequest.h"

@implementation GetInteractAfterStepRequestItem_afterSteps
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"afterStepsId"}];
}
@end

@implementation GetInteractAfterStepRequestItem_data
@end

@implementation GetInteractAfterStepRequestItem
@end

@implementation GetInteractAfterStepRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.afterStep";
    }
    return self;
}
@end
