//
//  GetCourseCommentRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetCourseCommentRequestItem_element <NSObject>
@end
@interface GetCourseCommentRequestItem_element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *anonymous;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *replyNum;
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *replyCommentRecordId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *commentId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *replays;
@property (nonatomic, strong) NSString<Optional> *userLiked;
@end

@interface GetCourseCommentRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<Optional,GetCourseCommentRequestItem_element> *elements;
@property (nonatomic, strong) NSString<Optional> *callbackParam;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@property (nonatomic, strong) NSString<Optional> *totalElements;

@property (nonatomic, strong) NSString<Ignore> *title;
@end

@interface GetCourseCommentRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCourseCommentRequestItem_data<Optional> *data;
@end

@interface GetCourseCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@property (nonatomic, strong) NSString<Optional> *limit;
@property (nonatomic, strong) NSString<Optional> *order;
@end
