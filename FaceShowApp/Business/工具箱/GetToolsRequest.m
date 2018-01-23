//
//  GetToolsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetToolsRequest.h"

@implementation GetToolsRequestItem_eventObj
@end

@implementation GetToolsRequestItem_tool
@end

@implementation GetToolsRequestItem_data
@end

@implementation GetToolsRequestItem
@end

@implementation GetToolsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.tools.getTools";
    }
    return self;
}
@end
