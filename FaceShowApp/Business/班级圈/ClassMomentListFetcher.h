//
//  ClassMomentListFetcher.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "ClassMomentListRequest.h"
@interface ClassMomentListFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *clazsId;
@end
