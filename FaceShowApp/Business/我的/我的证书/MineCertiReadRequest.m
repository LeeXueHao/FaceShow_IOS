//
//  MineCertiReadRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/10/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MineCertiReadRequest.h"

@implementation MineCertiReadRequest_Item
@end

@implementation MineCertiReadRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.cert.readCert";
    }
    return self;
}
@end
