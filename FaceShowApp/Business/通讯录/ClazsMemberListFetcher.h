//
//  ClazsMemberListFetcher.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "ClazsMemberListRequest.h"

extern NSString * const kClassMemberDidChangeNotification;

@interface ClazsMemberListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString<Optional> *keyWords;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
