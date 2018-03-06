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
#import "ContactsSearchBarView.h"
#import "ContactsCurrentClassView.h"
#import "ContactsClassFilterView.h"
#import "AlertView.h"

@interface ContactsViewController ()
@property(nonatomic, strong) ContactsSearchBarView *searchView;
@property(nonatomic, assign) BOOL isSearching;
@property(nonatomic, strong) NSMutableArray *filteredDataArray;
@property(nonatomic, strong) ContactsCurrentClassView *currentClassView;
@property(nonatomic, strong) ContactsClassFilterView *classFilterView;
@property(nonatomic, strong) AlertView *alertView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    ClazsMemberListFetcher *fetcher = [[ClazsMemberListFetcher alloc] init];
    fetcher.pagesize = 10;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    self.title = @"通讯录";
    [self setupUI];
    self.isSearching = NO;
    self.filteredDataArray = [NSMutableArray array];
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
    self.searchView =  [[ContactsSearchBarView alloc]init];
    WEAK_SELF
    [self.searchView setSearchBlock:^(NSString *text){
        STRONG_SELF
        self.isSearching = YES;
        [self searchContanctslWithKeyword:text];
    }];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(34);
    }];
    
    self.currentClassView = [[ContactsCurrentClassView alloc]init];
    self.currentClassView.title = @"终极一班";
    [self.currentClassView setContactsClassStartFilterBlock:^(NSString *currentTitle) {
        STRONG_SELF
        [self showFilterView];
    }];
    [self.view addSubview:self.currentClassView];
    [self.currentClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(51.f);
    }];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ContactsCell class] forCellReuseIdentifier:@"ContactsCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.currentClassView.mas_bottom);
    }];
    
    self.classFilterView = [[ContactsClassFilterView alloc]init];
    self.classFilterView.selectedRow = 0;
}

- (void)searchContanctslWithKeyword:(NSString *)keyword {
    //    if (keyword.length <= 0) {
    //        return;
    //    }
    //    for (int i = 0; i < self.dataArray.count; i++) {
    //        GetUserInfoRequestItem_Data *member = self.dataArray[0][i];
    //        NSString *string = member.realName;
    //        if (string.length >= keyword.length) {
    //            if ([string rangeOfString:keyword].location != NSNotFound) {
    //                [self.filteredDataArray addObject:member];
    //                [self.tableView reloadData];
    //            }
    //        }
    //    }
}

- (void)showFilterView {
    if (self.alertView.superview) {
        return;
    }
    
    ContactsClassFilterView *filterView = self.classFilterView;
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = filterView;
    self.alertView = alert;
    CGFloat selectionViewHeight = [self.classFilterView heightForContactsClassFilterView];
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [self hideFilterView];
    }];
    [alert showInView:self.view withLayout:^(AlertView *view) {
        STRONG_SELF
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(99.f);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.bottom.equalTo(view.mas_top).offset(0);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(view.mas_top).offset(0);
                make.height.mas_equalTo(selectionViewHeight);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [filterView setContactsClassFilterCompletedBlock:^(NSString *selectedTitle, NSInteger selectedRow) {
        STRONG_SELF
        [alert hide];
        if (![selectedTitle isEqualToString:self.currentClassView.title]) {
            self.currentClassView.title = selectedTitle;
        }
        //切换相应的班级的联系人列表
        //进行筛选
    }];
    
}

- (void)hideFilterView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.classFilterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.alertView);
            make.bottom.equalTo(self.alertView.mas_top).offset(0);
        }];
        [self.alertView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.alertView removeFromSuperview];
        self.currentClassView.isFiltering = NO;
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.isSearching) {
//        return self.filteredDataArray.count;
//    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.isSearching) {
//        return [self.filteredDataArray[section] count];
//    }
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
//    if (self.isSearching) {
//        cell.data = self.filteredDataArray[indexPath.section][indexPath.row];
//        cell.isLastRow = indexPath.row == [self.filteredDataArray[indexPath.section] count] - 1;
//    }
    cell.data = self.dataArray[indexPath.section][indexPath.row];
    cell.isLastRow = indexPath.row == [self.dataArray[indexPath.section] count] - 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *chatVC = [[ChatViewController alloc]init];
#warning 此处的member后续还需要看通讯录的结构是什么
    IMMember *member;
    GetUserInfoRequestItem_Data *data;
    if (self.isSearching) {
//         data = self.filteredDataArray[indexPath.section][indexPath.row];
    }else {
        data = self.dataArray[indexPath.section][indexPath.row];
    }
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.isSearching = NO;
    [self.searchView.textField resignFirstResponder];
}

- (void)setIsSearching:(BOOL)isSearching {
    _isSearching = isSearching;
//    [self.tableView reloadData];
}
@end
