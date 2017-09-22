//
//  NoticeListFetcher.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeListFetcher.h"
#import "GetNoticeListRequest.h"

@interface NoticeListFetcher ()
@property (nonatomic, strong) GetNoticeListRequest *request;
@end

@implementation NoticeListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetNoticeListRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.clazsId = self.clazzId;
    self.request.title = self.title;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetNoticeListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetNoticeListRequestItem *item = (GetNoticeListRequestItem *)retItem;
        self.lastID += item.data.elements.count;
        BLOCK_EXEC(aCompleteBlock, item.data.totalElements.integerValue, item.data.elements, nil)
    }];
}
@end
