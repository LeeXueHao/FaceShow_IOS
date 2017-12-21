//
//  MineViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "MineUserHeaderCell.h"
#import "MineDefaultCell.h"
#import "MineTableFooterView.h"
#import "FSDefaultHeaderFooterView.h"
#import "UserInfoViewController.h"
#import "SignInRecordViewController.h"
#import "UserModel.h"
#import "FeedbackViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) GetUserInfoRequest *userInfoRequest;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    self.titleArray = @[@{@"image":@"签到记录icon",@"title":@"签到记录"},
                        @{@"image":@"意见反馈icon",@"title":@"意见反馈"}
                        ];
    [self setupUI];
    [self setupLayout];
    if ([UserManager sharedInstance].userModel == nil) {
        [self requestForUserInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.tableView registerClass:[MineUserHeaderCell class] forCellReuseIdentifier:@"MineUserHeaderCell"];
    [self.tableView registerClass:[MineDefaultCell class] forCellReuseIdentifier:@"MineDefaultCell"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.view addSubview:self.tableView];
    MineTableFooterView *footerView = [[MineTableFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34.0f + 45.0f)];
    WEAK_SELF
    [[footerView.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        DDLogDebug(@"登出");
        [UserManager sharedInstance].loginStatus = NO;
    }];
    self.tableView.tableFooterView = footerView;
    
}
- (void)setupLayout {
    //containerView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75.5f;
    }else{
        return 45.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        UserInfoViewController *VC = [[UserInfoViewController alloc] init];
        WEAK_SELF
        [VC setCompleteBlock:^{
            STRONG_SELF
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:VC animated:YES];
//        UIViewController *VC = [[NSClassFromString(@"PhotoChooseViewController") alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section == 1){
        SignInRecordViewController *signInRecordVC = [[SignInRecordViewController alloc] init];
        [self.navigationController pushViewController:signInRecordVC animated:YES];
    }else {
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataScource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MineUserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineUserHeaderCell" forIndexPath:indexPath];
        [cell reload];
        return cell;
    }else {
        MineDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineDefaultCell" forIndexPath:indexPath];
        cell.contenDictionary = self.titleArray[indexPath.section - 1];
        return cell;
    }
}
#pragma mark - request
- (void)requestForUserInfo{
    GetUserInfoRequest *request = [[GetUserInfoRequest alloc] init];
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        GetUserInfoRequestItem *item = retItem;
        if (item.data != nil) {
            [[UserManager sharedInstance].userModel updateFromUserInfo:item.data];
            [self.tableView reloadData];
        }
    }];
    self.userInfoRequest = request;
}
@end
