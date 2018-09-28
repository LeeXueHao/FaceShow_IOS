//
//  MineCertiViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MineCertiViewController.h"
#import "MineCertiListFetcher.h"
#import "YXShowPhotosViewController.h"
#import "CertificateCell.h"
#import "CertificateHeaderView.h"
@interface MineCertiViewController ()

@end

@implementation MineCertiViewController

- (void)viewDidLoad {
    MineCertiListFetcher *fetcher = [[MineCertiListFetcher alloc]init];
//    fetcher
//    self.dataFetcher = fetcher;
    [super viewDidLoad];
    self.navigationItem.title = @"我的证书";
    [self setupUI];
    [self setupObserver];
    [self.view nyx_stopLoading];
    [self setupMock];
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    self.tableView.rowHeight = 60;
    self.tableView.sectionHeaderHeight = 75;
    [self.tableView registerClass:[CertificateCell class] forCellReuseIdentifier:@"CertificateCell"];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
    }];

}

- (void)setupMock{
    self.dataArray = [NSMutableArray arrayWithObjects:@(2),@(4),nil];
    [self.tableView reloadData];
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kReloadSignInRecordNotification" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        [self.tableView reloadRowsAtIndexPaths:@[@(1)] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CertificateCell"];
//    GetSignInRecordListRequestItem_Element *element = self.dataArray[indexPath.section];
//    cell.hasBottomLine = indexPath.row != element.signIns.count - 1;
//    cell.signIn = element.signIns[indexPath.row];
    cell.isLastRow = indexPath.row == [self.dataArray[indexPath.section] integerValue] - 1;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    GetSignInRecordListRequestItem_Element *element = self.dataArray[section];
//    return element.signIns.count;
    return [self.dataArray[section] integerValue];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return 60;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//    return 75;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CertificateHeaderView *header = [[CertificateHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 75)];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXShowPhotosViewController *VC = [[YXShowPhotosViewController alloc] init];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    VC.imageURLMutableArray = [NSMutableArray arrayWithObjects:@"", nil];
    VC.animateRect = [self.view convertRect:cell.frame toView:self.view];
    [self.navigationController presentViewController:VC animated:YES completion:^{

    }];

}


#pragma mark - RefreshDelegate
- (void)refreshUI {
    [self.view nyx_startLoading];
    [self firstPageFetch];
}
@end
