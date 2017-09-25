//
//  QAFileUploadSecondStepRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAFileUploadSecondStepRequest.h"

@implementation QAFileUploadSecondStepRequestItem_result
@end

@implementation QAFileUploadSecondStepRequestItem
@end

@implementation QAFileUploadSecondStepRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"http://newupload.yanxiu.com/fileUpload";
    }
    return self;
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    // set cookie
    NSMutableDictionary *cp1 = [NSMutableDictionary dictionary];
    [cp1 setObject:@"client_type" forKey:NSHTTPCookieName];
    [cp1 setObject:@"app" forKey:NSHTTPCookieValue];
    [cp1 setObject:@"newupload.yanxiu.com" forKey:NSHTTPCookieDomain];
    [cp1 setObject:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cp1];
    
    NSMutableDictionary *cp2 = [NSMutableDictionary dictionary];
    [cp2 setObject:@"passport" forKey:NSHTTPCookieName];
    NSString *name = [UserManager sharedInstance].userModel.passport;
    [cp2 setObject:name forKey:NSHTTPCookieValue];
    [cp2 setObject:@"newupload.yanxiu.com" forKey:NSHTTPCookieDomain];
    [cp2 setObject:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cp2];
    [self.request setRequestCookies:[NSMutableArray arrayWithArray:@[cookie1, cookie2]]];
    
    // 参数
    self.status = @"upinfo";
    self.domain = @"main.zgjiaoyan.com";
    self.isexist = @"0";
//    NSString *reserve = @"{\"typeId\":1000,\"title\":\"iosTestFile\",\"username\":\"研修网崔志伟\",\"uid\":20103549,\"shareType\":0,\"from\":6,\"source\":\"pc\",\"description\":\"\"}";
    NSString *reserve = [NSString stringWithFormat:@"{\"typeId\":1000,\"title\":\"%@\",\"username\":\"%@\",\"uid\":\"%@\",\"shareType\":0,\"from\":6,\"source\":\"ios\",\"description\":\"\"}",self.filename,name,
                         [UserManager sharedInstance].userModel.userID 
                         ];

    self.reserve = reserve;
    [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
}
- (NSString *)typeForImageData:(NSData *)data {
    
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}

@end
