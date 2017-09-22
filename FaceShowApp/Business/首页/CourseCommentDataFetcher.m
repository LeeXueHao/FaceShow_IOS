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
    if (self.lastID != 0) {
        self.request.callbackValue = [NSString stringWithFormat:@"%@",@(self.lastID)];
    }
    self.request.limit = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetCourseCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        BLOCK_EXEC(self.finishBlock,retItem);
        GetCourseCommentRequestItem *item = (GetCourseCommentRequestItem *)retItem;
        BLOCK_EXEC(aCompleteBlock,item.data.totalElements.intValue,item.data.elements,nil);
        if (item.data.elements.count > 0) {
            GetCourseCommentRequestItem_element *element = [item.data.elements lastObject];
            self.lastID = element.elementId.integerValue;
        }
    }];
}

@end
