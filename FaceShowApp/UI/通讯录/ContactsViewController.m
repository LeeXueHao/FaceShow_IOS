//
//  ContactsViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsViewController.h"
#import "ClazsMemberListFetcher.h"
#import "ContactsCell.h"
#import "ChatViewController.h"
#import "IMDatabaseManager.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    ClazsMemberListFetcher *fetcher = [[ClazsMemberListFetcher alloc] init];
    fetcher.pagesize = 10;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    self.title = @"通讯录";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];
    
    SAFE_CALL(self.requestDelegate, requestWillRefresh);
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        SAFE_CALL_OneParam(self.requestDelegate, requestEndRefreshWithError, error);
        [self.view nyx_stopLoading];
        [self stopAnimation];
        if (error) {
            if (isEmpty(self.dataArray)) {  // no cache 强提示, 加载失败界面
                self->_total = 0;
                [self showErroView];
            } else {
                [self.view nyx_showToast:error.localizedDescription];
            }
            [self checkHasMore];
            return;
        }
        
        // 隐藏失败界面
        [self hideErrorView];
        
        [self->_header setLastUpdateTime:[NSDate date]];
        self.total = total;
        [self.dataArray removeAllObjects];
        
        if (isEmpty(retItemArray.firstObject) && isEmpty(retItemArray.lastObject)) {
            self.emptyView.hidden = NO;
        } else {
            self.emptyView.hidden = YES;
            [self.dataArray addObjectsFromArray:retItemArray];
            [self checkHasMore];
            [self.dataFetcher saveToCache];
        }
        [self.tableView reloadData];
    }];
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    SAFE_CALL(self.requestDelegate, requestWillFetchMore);
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        SAFE_CALL_OneParam(self.requestDelegate, requestEndFetchMoreWithError, error);
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self->_footer endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            
            NSMutableArray *students = [NSMutableArray arrayWithArray:self.dataArray.lastObject];
            [students addObjectsFromArray:retItemArray.lastObject];
            self.dataArray[1] = students;
            self.total = total;
            [self.tableView reloadData];
            [self checkHasMore];
        });
    }];
}

- (void)showErroView {
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
}

- (void)checkHasMore {
    [self setPullupViewHidden:[self.dataArray.lastObject count] >= _total];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ContactsCell class] forCellReuseIdentifier:@"ContactsCell"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.section][indexPath.row];
    cell.isLastRow = indexPath.row == [self.dataArray[indexPath.section] count] - 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *chatVC = [[ChatViewController alloc]init];
#warning 此处的member后续还需要看通讯录的结构是什么
    IMMember *member;
    GetUserInfoRequestItem_Data *data = self.dataArray[indexPath.section][indexPath.row];
    if (data.imTokenInfo) {
        member = [data.imTokenInfo.imMember toIMMember];
    }else {
        member = [[IMMember alloc]init];
        member.userID = [data.userId integerValue];
        member.name = data.realName;
        member.avatar = data.avatar;
    }
    IMTopic *topic = [[IMDatabaseManager sharedInstance] findTopicWithMember:member];
    if (topic) {
        chatVC.topic = topic;
    }else {
        chatVC.member = member;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
