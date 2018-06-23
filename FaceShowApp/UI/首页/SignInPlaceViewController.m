//
//  SignInPlaceViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/5/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPlaceViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "SignInPLaceCell.h"
#import "PositionSignInRequest.h"
#import "UserSignInRequest.h"
#import "ScanCodeResultViewController.h"
#import "MJRefresh.h"

@interface SignInPlaceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) PositionSignInRequest *positionListRequest;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UserSignInRequest *signInRequest;

@end

@implementation SignInPlaceViewController
- (void)dealloc {
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置签到";
    [self setupUI];
    [self requestSignInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {    
    UIView *titleBgView = [[UIView alloc]init];
    titleBgView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.font = [UIFont boldSystemFontOfSize:14];
    titleLable.textColor = [UIColor colorWithHexString:@"999999"];
    titleLable.text = @"当前可签到:";
    [titleBgView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[SignInPLaceCell class] forCellReuseIdentifier:@"SignInPLaceCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleBgView.mas_bottom);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    WEAK_SELF
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestSignInfo];
    };
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无位置签到";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestSignInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView.hidden = YES;
}

- (void)requestSignInfo {
    [self.view nyx_startLoading];
    [self.positionListRequest stopRequest];
    self.positionListRequest = [[PositionSignInRequest alloc]init];
    self.positionListRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    WEAK_SELF
    [self.positionListRequest startRequestWithRetClass:[PositionSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.header endRefreshing];
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        PositionSignInRequestItem *item = (PositionSignInRequestItem *)retItem;
        if (item.data.signIns.count == 0) {
            self.emptyView.hidden = NO;
            return;
        }
        self.dataArray = item.data.signIns;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInPLaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInPLaceCell"];
    GetSignInRecordListRequestItem_SignIn *data = self.dataArray[indexPath.row];
    cell.data = data;
    WEAK_SELF
    [cell setSignInPlaceBlock:^{
        STRONG_SELF
        [self signInWithData:data];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

#pragma mark - 位置签到
- (void)signInWithData:(GetSignInRecordListRequestItem_SignIn *)data {
    [self.view nyx_startLoading];
    [self.signInRequest stopRequest];
    self.signInRequest = [[UserSignInRequest alloc] init];
    self.signInRequest.stepId = data.stepId;
    self.signInRequest.positionSignIn = YES;
    self.signInRequest.positionRange = data.positionRange;
    self.signInRequest.signinPosition = data.signinPosition;
    WEAK_SELF
    [self.signInRequest startRequestWithRetClass:[UserSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error && (error.code == 1||error.code == -1)) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        UserSignInRequestItem *item = (UserSignInRequestItem *)retItem;
        ScanCodeResultViewController *scanCodeResultVC = [[ScanCodeResultViewController alloc] init];
        scanCodeResultVC.data = error ? nil : item.data;
        scanCodeResultVC.error = error ? item.error : nil;
        scanCodeResultVC.positionSignIn = YES;
        [self.navigationController pushViewController:scanCodeResultVC animated:YES];
    }];
}

@end
