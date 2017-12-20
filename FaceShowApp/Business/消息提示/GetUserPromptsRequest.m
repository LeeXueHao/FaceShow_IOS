//
//  GetUserPromptsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/12/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetUserPromptsRequest.h"

@implementation GetUserPromptsRequestItem_taskNew
@end

@implementation GetUserPromptsRequestItem_momentNew
@end

@implementation GetUserPromptsRequestItem_resourceNew
@end

@implementation GetUserPromptsRequestItem_data
@end

@implementation GetUserPromptsRequestItem
@end

@implementation GetUserPromptsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"prompt.getUserPrompts";
    }
    return self;
}
@end
