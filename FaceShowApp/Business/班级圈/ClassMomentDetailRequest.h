//
//  ClassMomentDetailRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentDetailItem : HttpBaseRequestItem
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment<Optional> *data;
@end
@interface ClassMomentDetailRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *momentId;
@end
