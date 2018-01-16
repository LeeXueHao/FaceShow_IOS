//
//  ClassMomentCancelLikeRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ClassMomentCancelLikeRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *momentId;
@end
