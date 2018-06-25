//
//  TaskCommentFetcher.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskCommentFetcher.h"
#import "GetCommentRecordsRequest.h"
#import "QuestionRequestItem.h"
#import "GetCommentRequest.h"

@interface TaskCommentFetcher ()
@property (nonatomic, strong) GetCommentRequest *titleRequest;
@property (nonatomic, strong) GetCommentRecordsRequest *request;
@property (nonatomic, strong) NSString *title;
@end

@implementation TaskCommentFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.titleRequest stopRequest];
    self.titleRequest = [[GetCommentRequest alloc]init];
    self.titleRequest.stepId = self.stepId;
    WEAK_SELF
    [self.titleRequest startRequestWithRetClass:[GetCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        GetCommentRequestItem *item = (GetCommentRequestItem *)retItem;
        self.title = item.data.desc;
        [self requestCommentsWithCompleteBlock:aCompleteBlock];
    }];
  
}
- (void)requestCommentsWithCompleteBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetCommentRecordsRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.stepId = self.stepId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetCommentRecordsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetCommentRecordsRequestItem *item = (GetCommentRecordsRequestItem *)retItem;
        item.data.title = self.title;
        self.lastID += item.data.elements.count;
        BLOCK_EXEC(self.finishBlock,retItem);
        BLOCK_EXEC(aCompleteBlock, item.data.totalElements.intValue, item.data.elements, nil)
    }];
}

@end
