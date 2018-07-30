//
//  QiniuTokenRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QiniuTokenRequest.h"
#import "QiniuConfig.h"

@implementation QiniuTokenRequestItem_data
@end

@implementation QiniuTokenRequestItem
@end

@interface QiniuTokenRequest()
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *dtype;
@end

@implementation QiniuTokenRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kQiniuServer;
        self.method = @"upload.token";
        self.from = @"22";
        self.dtype = @"app";
    }
    return self;
}

@end
