//
//  GetCommentRecordsRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"


@protocol GetCommentRecordsRequestItem_element <NSObject>
@end
@interface GetCommentRecordsRequestItem_element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *anonymous;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *replyNum;
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *replyCommentRecordId;
@property (nonatomic, strong) NSString<Optional> *commentId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *replays;
@property (nonatomic, strong) NSString<Optional> *userLiked;
@end

@interface GetCommentRecordsRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<Optional,GetCommentRecordsRequestItem_element> *elements;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Ignore> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSString<Ignore> *lastPageNumber;

@property (nonatomic, strong) NSString<Ignore> *title;
@end

@interface GetCommentRecordsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCommentRecordsRequestItem_data<Optional> *data;
@end

@interface GetCommentRecordsRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *orderBy;//排序：可以多字段排序 例如 create_time desc,status asc
@end
