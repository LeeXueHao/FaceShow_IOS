//
//  FeedbackRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2017/12/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FeedbackRequest.h"

@implementation FeedbackRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.method = @"feedback.submitFeedback";
        self.appId = @"22";
        self.sourceId = @"1";
        self.platId = @"100";
    }
    return self;
}
@end
