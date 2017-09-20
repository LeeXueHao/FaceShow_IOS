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

@interface GetNoticeListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetNoticeListRequestItem_Notice, Optional> *data;
@end

@interface GetNoticeListRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazzId;
@property (nonatomic, strong) NSString *offset;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString<Optional> *title;
@end
