//
//  NoticeListFetcher.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface NoticeListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *clazzId;
@property (nonatomic, strong) NSString *title;
@end
