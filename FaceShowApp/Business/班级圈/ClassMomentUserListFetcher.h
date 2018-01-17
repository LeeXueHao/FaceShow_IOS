//
//  ClassMomentUserListFetcher.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface ClassMomentUserListFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *userId;
@end
