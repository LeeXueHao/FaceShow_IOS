//
//  TaskRankingFetcher.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskRankingFetcher.h"
#import "GetUserTasksProgressRankRequest.h"

@interface TaskRankingFetcher ()
@property (nonatomic, strong) GetUserTasksProgressRankRequest *request;
@end

@implementation TaskRankingFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetUserTasksProgressRankRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.clazsId = self.clazzId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetUserTasksProgressRankRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetUserTasksProgressRankRequestItem *item = (GetUserTasksProgressRankRequestItem *)retItem;
        self.lastID += item.data.userRank.elements.count;
        BLOCK_EXEC(aCompleteBlock, item.data.userRank.totalElements.intValue, item.data.userRank.elements, nil)
    }];
}
@end
