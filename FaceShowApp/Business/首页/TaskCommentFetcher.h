//
//  TaskCommentFetcher.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
@class GetCommentRecordsRequestItem;

@interface TaskCommentFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) void(^finishBlock) (GetCommentRecordsRequestItem *item);
@end
