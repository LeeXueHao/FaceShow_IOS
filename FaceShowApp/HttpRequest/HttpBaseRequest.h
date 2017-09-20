//
//  HttpBaseRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "JSONModel.h"
#import "HttpBaseRequestItem_Error.h"

static NSString *const YXTokenInValidNotification = @"kYXTokenInValidNotification";

@interface HttpBaseRequestItem : JSONModel

@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *message;
@property (nonatomic, strong) HttpBaseRequestItem_Error<Optional> *error;

@end


typedef void(^HttpRequestCompleteBlock)(id retItem, NSError *error, BOOL isMock);

@interface HttpBaseRequest : JSONModel {
    ASIHTTPRequest *_request;
    HttpRequestCompleteBlock _completeBlock;
    Class _retClass;
    BOOL _isMock;
}
@property (nonatomic, copy) NSString<Ignore> *urlHead;
@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *method;
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
