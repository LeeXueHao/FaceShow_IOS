//
//  ClassMomentCommentRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentCommentRequestItem :  HttpBaseRequestItem
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment_Comment *data;
@end
@interface ClassMomentCommentRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *claszId;
@property (nonatomic, copy) NSString<Optional> *momentId;
@property (nonatomic, copy) NSString<Optional> *content;
@end
