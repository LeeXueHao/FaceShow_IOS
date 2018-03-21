//
//  SaveImageMsgRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SaveImageMsgRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation SaveImageMsgRequestItem
@end

@interface SaveImageMsgRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation SaveImageMsgRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.saveImageMsg";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
    }
    return self;
}
@end
