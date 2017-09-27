//
//  MessageHasUnViewRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface MessageHasUnViewRequestItem_Data : JSONModel
@property (nonatomic, assign) BOOL hasUnView;
@end

@interface MessageHasUnViewRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) MessageHasUnViewRequestItem_Data<Optional> *data;
@end

@interface MessageHasUnViewRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
