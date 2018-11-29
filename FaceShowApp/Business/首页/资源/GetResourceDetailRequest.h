//
//  GetResourceDetailRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetResourceDetailRequestItem_Data_Ai : JSONModel
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *ext;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@property (nonatomic, strong) NSString<Optional> *transcodeStatus;
@property (nonatomic, strong) NSString<Optional> *resThumb;
@end

@interface GetResourceDetailRequestItem_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *resourceId;
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
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@property (nonatomic, strong) GetResourceDetailRequestItem_Data_Ai<Optional> *ai;
@end

@interface GetResourceDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetResourceDetailRequestItem_Data<Optional> *data;
@end

@interface GetResourceDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *resId;
@end
