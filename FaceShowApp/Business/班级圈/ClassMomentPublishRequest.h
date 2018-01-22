//
//  ClassMomentPublishRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentPublishRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment<Optional> *data;
@end

// http://wiki.yanxiu.com/pages/viewpage.action?pageId=12322954
@interface ClassMomentPublishRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *resourceIds;//上传资源id集合,逗号分隔，e.g:22,33,55
@property (nonatomic, copy) NSString<Optional> *resourceSource;
@end
