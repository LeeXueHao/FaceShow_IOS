//
//  MessageViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"
#import "NoticeListFetcher.h"
#import "GetNoticeListRequest.h"
#import "UserMessageManager.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    NoticeListFetcher *fetcher = [[NoticeListFetcher alloc] init];
    fetcher.clazzId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self setupUI];
    [self setupObserver];
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
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewMessageNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self firstPageFetch];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    GetNoticeListRequestItem_Notice *notice = self.dataArray[indexPath.row];
    cell.notice = notice;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GetNoticeListRequestItem_Notice *notice = self.dataArray[indexPath.row];
    MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc] init];
    messageDetailVC.noticeId = notice.noticeId;
    messageDetailVC.viewed = notice.viewed;
    WEAK_SELF
    messageDetailVC.fetchNoticeDetailSucceedBlock = ^{
        STRONG_SELF
        notice.viewed = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

@end
