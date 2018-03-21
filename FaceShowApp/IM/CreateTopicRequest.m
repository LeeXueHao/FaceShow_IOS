//
//  CreateTopicRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/2/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateTopicRequest.h"
#import "IMConfig.h"
#import "IMManager.h"

@implementation CreateTopicRequestItem_data

@end

@implementation CreateTopicRequestItem

@end

@interface CreateTopicRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation CreateTopicRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.createTopic";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
    }
    return self;
}
@end
