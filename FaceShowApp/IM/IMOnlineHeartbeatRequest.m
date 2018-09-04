//
//  IMOnlineHeartbeatRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/9/4.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMOnlineHeartbeatRequest.h"
#import "IMConfig.h"
#import "IMManager.h"

@interface IMOnlineHeartbeatRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *reqId;
@property (nonatomic, strong) NSString *onlineSeconds;
@end

@implementation IMOnlineHeartbeatRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"online.heartbeat";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
        self.type = @"app";
        self.onlineSeconds = @"60";
        self.reqId = [IMConfig generateUniqueID];
    }
    return self;
}
@end
