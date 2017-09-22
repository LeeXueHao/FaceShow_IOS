//
//  UserSignInRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInRequest.h"

@implementation UserSignInRequestItem_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"userSignInId"}];
}
@end

@implementation UserSignInRequestItem
@end

@interface UserSignInRequest ()
@property (nonatomic, strong) NSString *device;
@end

@implementation UserSignInRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.userSignIn";
        self.device = @"ios";
    }
    return self;
}
@end
