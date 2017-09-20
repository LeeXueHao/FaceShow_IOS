//
//  GetVoteRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetVoteRequest.h"

@implementation GetVoteRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.getVote";
    }
    return self;
}
@end
