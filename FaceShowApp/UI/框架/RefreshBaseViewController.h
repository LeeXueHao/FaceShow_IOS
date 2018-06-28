//
//  RefreshBaseViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/27.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "HttpBaseRequest.h"

@interface RefreshBaseViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;

- (void)startRequest;
- (HttpBaseRequest *)request; // 需要子类实现
- (void)handleRequestResponse:(id)retItem error:(NSError *)error mock:(BOOL)isMock; // 需要子类实现
@end
