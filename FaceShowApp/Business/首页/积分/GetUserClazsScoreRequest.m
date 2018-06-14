//
//  GetUserClazsScoreRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserClazsScoreRequest.h"

@implementation GetUserClazsScoreRequestItem_userScoreItem
@end

@implementation GetUserClazsScoreRequestItem_userScore
@end

@implementation GetUserClazsScoreRequestItem_data
@end

@implementation GetUserClazsScoreRequestItem
@end


@implementation GetUserClazsScoreRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"clazs.userClazsScore";
    }
    return self;
}
@end
