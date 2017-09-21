//
//  CourseCommentDataFetcher.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentDataFetcher.h"

@interface CourseCommentDataFetcher()
@property (nonatomic, strong) GetCourseCommentRequest *request;
@end

@implementation CourseCommentDataFetcher

- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetCourseCommentRequest alloc]init];
    self.request.stepId = self.stepId;
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetCourseCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        BLOCK_EXEC(self.finishBlock,retItem);
        GetCourseCommentRequestItem *item = (GetCourseCommentRequestItem *)retItem;
        self.lastID += item.data.elements.count;
        BLOCK_EXEC(aCompleteBlock,99999,item.data.elements,nil);
    }];
}

@end
