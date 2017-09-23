//
//  GetSignInRecordListFetcher.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetSignInRecordListFetcher.h"
#import "GetSignInRecordListRequest.h"

@interface GetSignInRecordListFetcher ()
@property (nonatomic, strong) GetSignInRecordListRequest *request;
@end

@implementation GetSignInRecordListFetcher

- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetSignInRecordListRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.orderBy = self.orderBy;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetSignInRecordListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetSignInRecordListRequestItem *item = (GetSignInRecordListRequestItem *)retItem;
        self.lastID += item.data.elements.count;
        BLOCK_EXEC(aCompleteBlock, item.data.totalElements.intValue, item.data.elements, nil)
    }];
}

@end
