//
//  ClassMomentDiscardRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentDiscardItem : HttpBaseRequestItem
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment<Optional> *data;
@end
@interface ClassMomentDiscardRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *momentId;
@end
