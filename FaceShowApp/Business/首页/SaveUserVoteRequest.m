//
//  SaveUserVoteRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SaveUserVoteRequest.h"

@implementation SaveUserVoteRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.saveUserVote";
    }
    return self;
}
@end
