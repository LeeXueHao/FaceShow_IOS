//
//  HttpBaseRequest.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "HttpBaseRequest.h"
#import "YXMockManager.h"
#import "AppDelegate.h"
#import <NSString+HTML.h>
#pragma mark - Url Arguments Category : NSString & NSDictionary
@interface NSDictionary (UrlArgumentsAdditions)
- (NSString *)httpArgumentsString;
@end

@interface NSString (UrlArgumentsAdditions)
- (NSString*)stringByEscapingForURLArgument;
- (NSString*)stringByUnescapingFromURLArgument;
@end



@implementation NSString (UrlArgumentsAdditions)
- (NSString*)stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}

- (NSString*)stringByUnescapingFromURLArgument {
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end

@implementation NSDictionary (UrlArgumentsAdditions)
- (NSString *)httpArgumentsString {
    NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSString *key in self.allKeys) {
        [arguments addObject:[NSString stringWithFormat:@"%@=%@",
                              [key stringByEscapingForURLArgument],
                              [[[self objectForKey:key] description] stringByEscapingForURLArgument]]];
    }
    
    return [arguments componentsJoinedByString:@"&"];
}
@end



#pragma mark -

@implementation HttpBaseRequestItem
@end

@implementation HttpBaseRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].server;
        self.token = [UserManager sharedInstance].userModel.token;
    }
    return self;
}
- (ASIHTTPRequest *)request {
    return nil; // 子类实现, GET / POST / UPLOAD
}

- (void)updateRequestUrlAndParams {
    
}

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    self->_completeBlock = completeBlock;
    self->_retClass = retClass;
    
    NSString *key = NSStringFromClass([self class]);
    if ([[YXMockManager sharedInstance] hasMockDataForKey:key]) {
        self->_isMock = YES;
        WEAK_SELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([YXMockManager sharedInstance].requestDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STRONG_SELF
            NSString *json = [[YXMockManager sharedInstance] mockDataForKey:key];
            [self dealWithResponseJson:json];
        });
        return;
    }

    self->_isMock = NO;
    [self updateRequestUrlAndParams];
    DDLogWarn(@"request : %@", [self request].url);
    @weakify(self);
    [[self request] setCompletionBlock:^{
        @strongify(self); if (!self) return;
        NSString *json = [[NSString alloc] initWithData:[self request].responseData encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\\""];
        json = [json stringByReplacingHTMLEntities];
        [self dealWithResponseJson:json];
    }];
    [[self request] setFailedBlock:^{
        @strongify(self); if (!self) return;
        NSError *error = [self request].error;
        if (error
            && [error.domain isEqualToString:NetworkRequestErrorDomain]) {
            NSString *title = @"";
            if (error.code == ASIConnectionFailureErrorType) {
                title = @"网络异常,请稍后重试";
            } else if (error.code == ASIRequestTimedOutErrorType) {
                title = @"请求超时,请稍后重试";
            }
            error = [NSError errorWithDomain:NetworkRequestErrorDomain code:ASIConnectionFailureErrorType userInfo:@{NSLocalizedDescriptionKey:title}]; // 网络异常提示
        }
        self->_completeBlock(nil, error, self->_isMock);
    }];
    
    [[self request] startAsynchronous];
}

- (void)stopRequest {
    [[self request] clearDelegatesAndCancel];
}

// 约定server返回的业务逻辑错误为非负整数
- (void)dealWithResponseJson:(NSString *)json
{
    // 解码对象不存在，直接返回json数据
    if (!_retClass || ![_retClass isSubclassOfClass:[JSONModel class]]) {
        _completeBlock(json, nil, self->_isMock);
        return;
    }
    
    NSError *error = nil;
    HttpBaseRequestItem *item = [[_retClass alloc] initWithString:json error:&error];
    // json格式错误
    if (error) {
        error = [NSError errorWithDomain:error.domain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据加载失败"}];
        _completeBlock(nil, error, self->_isMock);
        return;
    }
    if (item.code.integerValue == 9999) { // token失效
        [[NSNotificationCenter defaultCenter] postNotificationName:YXTokenInValidNotification
                                                            object:nil];
        return;
    }
    if ([NSStringFromClass(_retClass) isEqualToString:@"UploadHeadImgItem"]) {//头像上传接口特殊
        _completeBlock(item, nil, self->_isMock);
        return;
    }
    
    
    // 业务逻辑错误
    if (item.code.integerValue != 0 || !item.code) {
        error = [NSError errorWithDomain:@"数据错误" code:-2 userInfo:@{NSLocalizedDescriptionKey:item.error.message.length==0? @"数据错误":item.error.message}];
        _completeBlock(item, error, self->_isMock);
        return;
    }
    
    // 正常数据
    _completeBlock(item, nil, self->_isMock);
}

#pragma mark - private
- (NSDictionary *)_paramDict {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSDictionary *dict = [self toDictionary];
    for (NSString *key in [dict allKeys]) {
        id value = [dict valueForKey:key];
        if (isEmpty(value) && [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        [paramDict setValue:value forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:paramDict];
}

- (NSString *)_generateFullUrl {
    NSDictionary *paramDict = [self _paramDict];
    NSString *url = self.urlHead;
    if (!isEmpty(paramDict)) {
        url = [url stringByAppendingString:@"?"];
        url = [url stringByAppendingString:[paramDict httpArgumentsString]];
    }
    return url;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString: @"retryTimes"]) return YES;
    if ([propertyName isEqualToString: @"retryTimeinterval"]) return YES;
    if ([propertyName isEqualToString: @"request"]) return YES;
    if ([propertyName isEqualToString: @"completionBlock"]) return YES;
    if ([propertyName isEqualToString: @"requestType"]) return YES;
    if ([propertyName isEqualToString: @"bNeedRecord"]) return YES;
    return NO;
}

@end
