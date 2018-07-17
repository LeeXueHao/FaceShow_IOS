//
//  CourseCommentDataFetcher.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentDataFetcher.h"
#import "GetCourseCommentTitleRequest.h"

@interface CourseCommentDataFetcher()
@property (nonatomic, strong) GetCourseCommentRequest *request;
@property (nonatomic, strong) GetCourseCommentTitleRequest *titleRequest;
@property (nonatomic, strong) NSString *title;
@end

@implementation CourseCommentDataFetcher

- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.titleRequest stopRequest];
    self.titleRequest = [[GetCourseCommentTitleRequest alloc]init];
    self.titleRequest.stepId = self.stepId;
    WEAK_SELF
    [self.titleRequest startRequestWithRetClass:[GetCourseCommentTitleRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        GetCourseCommentTitleRequestItem *item = (GetCourseCommentTitleRequestItem *)retItem;
        self.title = item.data.title;
        [self requestCommentsWithCompleteBlock:aCompleteBlock];
    }];
}

- (void)requestCommentsWithCompleteBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
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
        GetCourseCommentRequestItem *item = (GetCourseCommentRequestItem *)retItem;
        item.data.title = self.title;
        BLOCK_EXEC(self.finishBlock,retItem);
        BLOCK_EXEC(aCompleteBlock,999999,item.data.elements,nil);
        if (item.data.elements.count > 0) {
            GetCourseCommentRequestItem_element *element = [item.data.elements lastObject];
            self.lastID = element.elementId.integerValue;
        }
    }];
}

@end
