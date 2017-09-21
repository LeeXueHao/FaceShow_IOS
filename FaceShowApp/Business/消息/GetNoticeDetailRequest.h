//
//  GetNoticeDetailRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetNoticeDetailRequestItem_Data : JSONModel
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

@interface GetNoticeDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetNoticeDetailRequestItem_Data<Optional> *data;
@end

@interface GetNoticeDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *noticeId;
@end
