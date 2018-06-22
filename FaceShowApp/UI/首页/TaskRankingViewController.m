//
//  TaskRankingViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskRankingViewController.h"
#import "TaskRankingFetcher.h"
#import "TaskRankingCell.h"

@interface TaskRankingViewController ()

@end

@implementation TaskRankingViewController

- (void)viewDidLoad {
    TaskRankingFetcher *fetcher = [[TaskRankingFetcher alloc] init];
    fetcher.clazzId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.estimatedRowHeight = 0;
    [self.tableView registerClass:[TaskRankingCell class] forCellReuseIdentifier:@"TaskRankingCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskRankingCell"];
    TaskRankingCellItem *item = [[TaskRankingCellItem alloc]init];
    item.element = self.dataArray[indexPath.row];
    item.rank = indexPath.row + 1;
    cell.item = item;
    if (indexPath.row == self.dataArray.count - 1) {
        cell.isShowLine = NO;
    }else {
        cell.isShowLine = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
}
@end
