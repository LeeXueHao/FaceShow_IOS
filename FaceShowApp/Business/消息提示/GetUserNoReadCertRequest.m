//
//  GetUserNoReadCertRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/10/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserNoReadCertRequest.h"

@implementation GetUserNoReadCertRequest_Item_data
@end

@implementation GetUserNoReadCertRequest_Item
@end

@implementation GetUserNoReadCertRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.cert.existNoReadCert";
    }
    return self;
}
@end
