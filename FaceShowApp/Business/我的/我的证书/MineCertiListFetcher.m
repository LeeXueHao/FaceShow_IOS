//
//  MineCertiListFetcher.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MineCertiListFetcher.h"
#import "MineCertiRequest.h"

@interface MineCertiListFetcher()

@property (nonatomic, strong) MineCertiRequest *request;

@end

@implementation MineCertiListFetcher

- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[MineCertiRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.orderBy = self.orderBy;
    WEAK_SELF
    [self.request startRequestWithRetClass:[MineCertiRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
//        MineCertiRequest_Item *item = (MineCertiRequest_Item *)retItem;
//        self.lastID += item.data.elements.count;
//        BLOCK_EXEC(aCompleteBlock, item.data.totalElements.intValue, item.data.elements, nil)
    }];
}



@end
