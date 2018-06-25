//
//  GetCommentRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetCommentRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@end

@interface GetCommentRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCommentRequestItem_data<Optional> *data;
@end

@interface GetCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@end
