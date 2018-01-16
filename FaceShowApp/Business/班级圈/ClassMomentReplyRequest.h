//
//  ClassMomentReplyRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentReplyItem :  HttpBaseRequestItem
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment_Comment<Optional> *data;
@end
@interface ClassMomentReplyRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *momentId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *toUserId;
@property (nonatomic, copy) NSString<Optional> *commentId;
@end
