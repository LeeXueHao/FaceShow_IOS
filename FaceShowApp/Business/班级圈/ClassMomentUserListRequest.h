//
//  ClassMomentUserListRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentUserListItem : HttpBaseRequestItem
@property(nonatomic, strong) ClassMomentListRequestItem_Data<Optional> *data;
@end
@interface ClassMomentUserListRequest : YXGetRequest

@end
