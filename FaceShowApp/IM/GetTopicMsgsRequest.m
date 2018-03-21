//
//  GetTopicMsgsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetTopicMsgsRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation GetTopicMsgsRequestItem
@end

@interface GetTopicMsgsRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation GetTopicMsgsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.getTopicMsgs";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
    }
    return self;
}
@end


