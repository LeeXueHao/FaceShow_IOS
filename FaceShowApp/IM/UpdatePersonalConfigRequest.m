//
//  UpdatePersonalConfigRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpdatePersonalConfigRequest.h"
#import "IMConfig.h"
#import "IMManager.h"

@implementation UpdatePersonalConfigRequestItem

@end

@interface UpdatePersonalConfigRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation UpdatePersonalConfigRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.updatePersonalConfig";
        self.reqId = [IMConfig generateUniqueID];
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
        self.bizSource = kBizSourse;
    }
    return self;
}
@end
