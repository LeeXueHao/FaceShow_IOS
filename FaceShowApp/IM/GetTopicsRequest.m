//
//  GetTopicsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetTopicsRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation GetTopicsRequestItem
@end

@interface GetTopicsRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation GetTopicsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.getTopics";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
    }
    return self;
}
@end
