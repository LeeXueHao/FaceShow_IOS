//
//  GetSignInRecordListFetcher.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface GetSignInRecordListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *orderBy;
@end
