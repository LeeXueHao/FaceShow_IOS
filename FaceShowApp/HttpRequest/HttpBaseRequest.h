//
//  HttpBaseRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "JSONModel.h"
#import "HttpBaseRequestItem_info.h"

static NSString *const YXTokenInValidNotification = @"kYXTokenInValidNotification";

@interface HttpBaseRequestItem : JSONModel

@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, strong) HttpBaseRequestItem_info<Optional> *info;

@end


typedef void(^HttpRequestCompleteBlock)(id retItem, NSError *error, BOOL isMock);

@interface HttpBaseRequest : JSONModel {
    ASIHTTPRequest *_request;
    HttpRequestCompleteBlock _completeBlock;
    Class _retClass;
    BOOL _isMock;
}
@property (nonatomic, copy) NSString<Ignore> *urlHead;
- (ASIHTTPRequest *)request;
- (void)updateRequestUrlAndParams;

- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock;

- (void)stopRequest;
- (void)dealWithResponseJson:(NSString *)json;

#pragma mark - private util
- (NSDictionary *)_paramDict;
- (NSString *)_generateFullUrl;
@end
