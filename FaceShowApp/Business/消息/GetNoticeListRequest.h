//
//  GetNoticeListRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetNoticeListRequestItem_Notice <NSObject>
@end
@interface GetNoticeListRequestItem_Notice : JSONModel
@property (nonatomic, strong) NSString<Optional> *noticeId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *authorId;
@property (nonatomic, strong) NSString<Optional> *clazzId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *updateTime;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *attachUrl;
@property (nonatomic, strong) NSString<Optional> *readNum;
@property (nonatomic, strong) NSString<Optional> *authorName;
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@property (nonatomic, strong) NSString<Optional> *updateTimeStr;
@property (nonatomic, assign) BOOL viewed;
@end

@interface GetNoticeListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetNoticeListRequestItem_Notice, Optional> *elements;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@end

@interface GetNoticeListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetNoticeListRequestItem_Data<Optional> *data;
@end

@interface GetNoticeListRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *title;
@end
