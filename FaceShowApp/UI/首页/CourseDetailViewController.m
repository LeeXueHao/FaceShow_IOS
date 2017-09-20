//
//  CourseDetailViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CourseDetailHeaderView.h"
#import "CourseCatalogCell.h"
#import "CourseBriefViewController.h"
#import "ProfessorDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    self.bNeedFooter = NO;
    self.bNeedHeader = NO;
    [super viewDidLoad];
    [self setupUI];
    [self.view nyx_stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView layoutIfNeeded];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CourseDetailHeaderView *headerView = [[CourseDetailHeaderView alloc] init];
    WEAK_SELF
    headerView.viewAllBlock = ^{
        STRONG_SELF
        CourseBriefViewController *courseBriefVC = [[CourseBriefViewController alloc] init];
        [self.navigationController pushViewController:courseBriefVC animated:NO];
    };
    self.tableView.tableHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.tableView registerClass:[CourseCatalogCell class] forCellReuseIdentifier:@"CourseCatalogCell"];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor greenColor];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(self.view.mas_top).offset(42);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogCell"];
    cell.title = @"水电费";
    cell.iconUrl = @"http://s1.jsyxw.cn/yanxiu/u/68/74/Img917468_80.jpg";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessorDetailViewController *professorDetailVC = [[ProfessorDetailViewController alloc] init];
    [self.navigationController pushViewController:professorDetailVC animated:NO];
}

@end
