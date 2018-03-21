//
//  GetMemberTopicsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetMemberTopicsRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation GetMemberTopicsRequestItem
@end

@interface GetMemberTopicsRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation GetMemberTopicsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.getMemberTopics";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
    }
    return self;
}
@end
