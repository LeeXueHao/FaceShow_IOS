//
//  MineCertiListFetcher.h
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface MineCertiListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString<Optional> *orderBy; // 排序，如 createTime desc，status asc
@end


