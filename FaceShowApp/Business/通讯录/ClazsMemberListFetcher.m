//
//  ClazsMemberListFetcher.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClazsMemberListFetcher.h"

NSString * const kClassMemberDidChangeNotification = @"kClassMemberDidChangeNotification";

@interface ClazsMemberListFetcher ()
@property (nonatomic, strong) ClazsMemberListRequest *request;
@end

@implementation ClazsMemberListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ClazsMemberListRequest alloc] init];
    self.request.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    self.request.keyWords = [NSString stringWithFormat:@"%@",self.keyWords];
    self.request.clazsId = self.clazsId;
    if (self.lastID != 0) {
        self.request.offset = [NSString stringWithFormat:@"%@", @(self.lastID)];
    }
    WEAK_SELF
    [self.request startRequestWithRetClass:[ClazsMemberListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock, 0, nil, error);
            return;
        }
        ClazsMemberListRequestItem *item = (ClazsMemberListRequestItem *)retItem;
        NSMutableArray *dataArray = [NSMutableArray array];
        [dataArray addObject:item.data.masters.count > 0 ? item.data.masters : @[]];
        [dataArray addObject:item.data.students.elements.count > 0 ? item.data.students.elements : @[]];
        self.lastID += item.data.students.elements.count;
        BLOCK_EXEC(aCompleteBlock, item.data.students.totalElements.intValue, dataArray, nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kClassMemberDidChangeNotification object:retItem];
    }];
}
@end
