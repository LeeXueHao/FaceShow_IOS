//
//  CourseCommentDataFetcher.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "GetCourseCommentRequest.h"

@interface CourseCommentDataFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) void(^finishBlock) (GetCourseCommentRequestItem *item);
@end
