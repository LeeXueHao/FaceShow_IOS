//
//  RefreshBaseViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/27.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "RefreshBaseViewController.h"
#import "MJRefresh.h"

@interface RefreshBaseViewController ()
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) HttpBaseRequest *dataRequest;
@end

@implementation RefreshBaseViewController
- (void)dealloc {
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBaseUI];
    [self startRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HttpBaseRequest *)request {
    return nil;
}

- (void)setupBaseUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    WEAK_SELF
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self startRequest];
    };
    
    self.emptyView = [[EmptyView alloc]init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self startRequest];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView.hidden = YES;
}

- (void)startRequest {
    [self.view nyx_startLoading];
    [self.dataRequest stopRequest];
    self.dataRequest = [self request];
    NSString *requestRetItemStr = [NSStringFromClass([self.dataRequest class]) stringByAppendingString:@"Item"];
    WEAK_SELF
    [self.dataRequest startRequestWithRetClass:NSClassFromString(requestRetItemStr) andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.header endRefreshing];
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        [self handleRequestResponse:retItem error:error mock:isMock];
    }];
}

- (void)handleRequestResponse:(id)retItem error:(NSError *)error mock:(BOOL)isMock {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
