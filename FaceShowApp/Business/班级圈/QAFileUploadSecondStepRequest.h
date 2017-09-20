//
//  QAFileUploadSecondStepRequest.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface QAFileUploadSecondStepRequestItem_result : JSONModel
@property (nonatomic, copy) NSString<Optional> *resid;
@end

@interface QAFileUploadSecondStepRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QAFileUploadSecondStepRequestItem_result<Optional> *result;
@end


@interface QAFileUploadSecondStepRequest : YXGetRequest
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *isexist;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *reserve;
@end
