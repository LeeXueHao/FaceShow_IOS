//
//  ScoreRankingFetcher.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreRankingFetcher.h"
#import "GetClazsSocresRequest.h"

@interface ScoreRankingFetcher ()
@property (nonatomic, strong) GetClazsSocresRequest *request;
@end

@implementation ScoreRankingFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetClazsSocresRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.clazsId = self.clazzId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetClazsSocresRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetClazsSocresRequestItem *item = (GetClazsSocresRequestItem *)retItem;
        self.lastID += item.data.elements.count;
        BLOCK_EXEC(aCompleteBlock, item.data.totalElements.intValue, item.data.elements, nil)
    }];
}
@end

