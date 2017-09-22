//
//  GetResourceRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetResourceRequestItem_Element <NSObject>
@end
@interface GetResourceRequestItem_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *pulisherId;
@property (nonatomic, strong) NSString<Optional> *publisherName;
@property (nonatomic, strong) NSString<Optional> *viewNum;
@property (nonatomic, strong) NSString<Optional> *downNum;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *suffix;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *clazzId;
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@end

@interface GetResourceRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetResourceRequestItem_Element, Optional> *elements;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@end

@interface GetResourceRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetResourceRequestItem_Data<Optional> *data;
@end

@interface GetResourceRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *keyword;
@end
