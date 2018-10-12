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
#import <sys/utsname.h>
#pragma mark - Url Arguments Category : NSString & NSDictionary
@interface NSDictionary (UrlArgumentsAdditions)
- (NSString *)httpArgumentsString;
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
#ifdef HuBeiApp
    NSString *name = @"FaceShow_Hubei";
#else
    NSString *name = @"FaceShow";
#endif
    NSString *version = [UIDevice currentDevice].systemVersion;
    [self.request setUserAgentString:[NSString stringWithFormat:@"%@, ios %@, %@ v%@",[self deviceModelName],version,name,[ConfigManager sharedInstance].clientVersion]];
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
        json = [json stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
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
    if (item.code.integerValue != 0) {
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
- (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}
@end
