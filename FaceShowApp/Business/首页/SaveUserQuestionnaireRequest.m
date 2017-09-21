//
//  SaveUserQuestionnaireRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SaveUserQuestionnaireRequest.h"

@implementation SaveUserQuestionnaireRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.saveUserQuestionnaire";
    }
    return self;
}
@end
