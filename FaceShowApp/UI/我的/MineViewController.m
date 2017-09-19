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
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.titleArray = @[@{@"image":@"sas",@"title":@"签到记录"}];
    [self setupUI];
    [self setupLayout];
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
        [self.navigationController pushViewController:VC animated:YES];
//        UIViewController *VC = [[NSClassFromString(@"PhotoChooseViewController") alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
    }else {
        DDLogDebug(@"扫码签到");
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
        return cell;
    }else {
        MineDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineDefaultCell" forIndexPath:indexPath];
        cell.contenDictionary = self.titleArray[indexPath.section - 1];
        return cell;
    }
}

@end
