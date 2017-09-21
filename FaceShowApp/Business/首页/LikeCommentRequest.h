//
//  LikeCommentRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface LikeCommentRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *userNum;
@end

@interface LikeCommentRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) LikeCommentRequestItem_data<Optional> *data;
@end

@interface LikeCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString *commentRecordId;
@end
