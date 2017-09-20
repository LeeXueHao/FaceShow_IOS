//
//  GetQuestionnaireRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetQuestionnaireRequest.h"

@implementation GetQuestionnaireRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.getQuestionnaire";
    }
    return self;
}
@end
