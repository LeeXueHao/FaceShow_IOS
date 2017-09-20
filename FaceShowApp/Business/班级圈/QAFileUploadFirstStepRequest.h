//
//  QAFileUploadFirstStepRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface QAFileUploadFirstStepRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *md5;
@property (nonatomic, copy) NSString<Optional> *size;
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *chunkSize;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *lastModifiedDate;
@end

@interface QAFileUploadFirstStepRequest : YXPostRequest
@property (nonatomic, strong) NSData<Ignore> *file;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastModifiedDate;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, copy) NSString *chunkSize;
@end
