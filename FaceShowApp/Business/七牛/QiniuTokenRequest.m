//
//  QiniuTokenRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QiniuTokenRequest.h"

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
        self.urlHead = @"http://niuugcupload.yanxiu.com/7up/platform/data.api";
        self.method = @"upload.token";
        self.from = @"100";
        self.dtype = @"app";
    }
    return self;
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
//    // set cookie
//    NSMutableDictionary *cp1 = [NSMutableDictionary dictionary];
//    [cp1 setObject:@"client_type" forKey:NSHTTPCookieName];
//    [cp1 setObject:@"app" forKey:NSHTTPCookieValue];
//    [cp1 setObject:@"newupload.yanxiu.com" forKey:NSHTTPCookieDomain];
//    [cp1 setObject:@"/" forKey:NSHTTPCookiePath];
//    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cp1];
//    
//    NSMutableDictionary *cp2 = [NSMutableDictionary dictionary];
//    [cp2 setObject:@"passport" forKey:NSHTTPCookieName];
//    NSString *name = [UserManager sharedInstance].userModel.passport;
//    [cp2 setObject:name forKey:NSHTTPCookieValue];
//    [cp2 setObject:@"newupload.yanxiu.com" forKey:NSHTTPCookieDomain];
//    [cp2 setObject:@"/" forKey:NSHTTPCookiePath];
//    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cp2];
//    [self.request setRequestCookies:[NSMutableArray arrayWithArray:@[cookie1, cookie2]]];
    
    
    [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
}

@end
