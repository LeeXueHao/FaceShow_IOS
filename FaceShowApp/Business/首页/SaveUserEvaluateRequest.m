//
//  SaveUserEvaluateRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SaveUserEvaluateRequest.h"

@implementation SaveUserEvaluateRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.saveUserEvaluate";
    }
    return self;
}
@end
