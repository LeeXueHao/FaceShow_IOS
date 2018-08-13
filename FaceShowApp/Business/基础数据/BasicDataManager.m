//
//  BasicDataManager.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BasicDataManager.h"
#import "BasicDataRequest.h"
#import "AreaManager.h"

@interface BasicDataManager()
@property (nonatomic, strong) BasicDataRequest *request;
@end

@implementation BasicDataManager

+ (BasicDataManager *)sharedInstance {
    static BasicDataManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BasicDataManager alloc] init];
    });
    return sharedInstance;
}

- (void)checkAndUpdataBasicData {
    [self.request stopRequest];
    self.request = [[BasicDataRequest alloc]init];
    WEAK_SELF
    [self.request startRequestWithRetClass:[BasicDataRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
        BasicDataRequestItem *item = retItem;
        for (BasicDataRequestItem_data *data in item.data) {
            if ([data.name isEqualToString:@"arealist"]) {
                [[AreaManager sharedInstance]updateWithLatestVersion:data.version url:data.url];
            }
        }
    }];
}

@end
