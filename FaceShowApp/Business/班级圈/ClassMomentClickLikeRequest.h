//
//  ClassMomentClickLikeRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentClickLikeRequestItem : HttpBaseRequestItem
@property (nonatomic,strong) ClassMomentListRequestItem_Data_Moment_Like<Optional> *data;
@end

@interface ClassMomentClickLikeRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *momentId;

@end
