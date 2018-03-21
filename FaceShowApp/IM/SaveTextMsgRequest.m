//
//  SaveTextMsgRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SaveTextMsgRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation SaveTextMsgRequestItem
@end

@interface SaveTextMsgRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation SaveTextMsgRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.saveTextMsg";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
    }
    return self;
}
@end
