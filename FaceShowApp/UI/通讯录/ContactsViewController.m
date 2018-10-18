//
//  ContactsViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsListCell.h"
#import "ContactsSearchBarView.h"
#import "ContactsCurrentClassView.h"
#import "ContactsClassFilterView.h"
#import "AlertView.h"
#import "IMConfig.h"
#import "IMMember.h"
#import "IMUserInterface.h"
#import "IMTopicInfoItem.h"
#import "HuBeiUserInfoViewController.h"
#import "UserInfoViewController.h"
#import "ContactsDetailViewController.h"
#import "HubeiContactsDetailViewController.h"
#import "ClassListRequest.h"
#import "ClazsMemberListFetcher.h"
#import "ClazsMemberListRequest.h"


@interface ContactsViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) ContactsSearchBarView *searchView;
@property(nonatomic, strong) ContactsCurrentClassView *currentClassView;
@property(nonatomic, strong) ContactsClassFilterView *classFilterView;
@property(nonatomic, strong) AlertView *alertView;
@property(nonatomic, assign) NSInteger currentSelectedGroupIndex;
@property (nonatomic, strong) NSArray<ClassListRequestItem_clazsInfos *> *totalClazsArray;
@property(nonatomic, strong) ClassListRequest *getClassRequest;
@property(nonatomic, strong) ClassListRequestItem *clazsListItem;
@property(nonatomic, strong) ClassListRequestItem_clazsInfos *selectedClass;
@property(nonatomic, copy) NSString *keywords;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.currentSelectedGroupIndex = 0;
    self.keywords = @"";
    self.emptyView = [[EmptyView alloc]init];
    self.errorView = [[ErrorView alloc]init];
    [self requestClasses];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestClasses {
    [self.getClassRequest stopRequest];
    self.getClassRequest = [[ClassListRequest alloc]init];
    self.getClassRequest.projectId = [UserManager sharedInstance].userModel.projectClassInfo.data.projectInfo.projectId;
    self.getClassRequest.userId = [UserManager sharedInstance].userModel.userID;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.getClassRequest startRequestWithRetClass:[ClassListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            WEAK_SELF
            [self.errorView setRetryBlock:^{
                STRONG_SELF
                [self requestClasses];
            }];
            return;
        }
        self.clazsListItem = (ClassListRequestItem *)retItem;
        if (self.clazsListItem.data.clazsInfos.count == 0) {
            [self.view nyx_stopLoading];
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            return;
        }
        self.classFilterView.clazsArray = self.clazsListItem.data.clazsInfos;
        self.selectedClass = self.clazsListItem.data.clazsInfos.firstObject;
        self.totalClazsArray = self.clazsListItem.data.clazsInfos;
        self.currentClassView.title = self.selectedClass.clazsName;
        self.currentClassView.selectClassId = self.selectedClass.clazsId;
        //取第一个进行请求
        //...
        [self firstPageFetch];
    }];
}

- (void)firstPageFetch{
    [self.dataFetcher stop];
    if(!self.selectedClass.clazsId){
        return;
    }
    ClazsMemberListFetcher *fetcher = [[ClazsMemberListFetcher alloc] init];
    fetcher.pagesize = 10;
    fetcher.keyWords = self.keywords;
    fetcher.clazsId = self.selectedClass.clazsId;
    self.dataFetcher = fetcher;
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
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
    WEAK_SELF
    self.searchView =  [[ContactsSearchBarView alloc]init];
    [self.searchView setSearchBlock:^(NSString *text){
        STRONG_SELF
        self.keywords = text;
        [self firstPageFetch];
        [TalkingData trackEvent:@"点击聊聊搜索框"];
    }];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(34);
    }];
    
    self.currentClassView = [[ContactsCurrentClassView alloc]init];
    [self.currentClassView setContactsClassStartFilterBlock:^(NSString *currentTitle) {
        STRONG_SELF
        [self.view endEditing:YES];
        [self showFilterView];
    }];
    [self.view addSubview:self.currentClassView];
    [self.currentClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(50.f);
    }];

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedSectionHeaderHeight = 0.f;
    self.tableView.estimatedSectionFooterHeight = 0.f;
    [self.tableView registerClass:[ContactsListCell class] forCellReuseIdentifier:@"ContactsListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.currentClassView.mas_bottom);
    }];
    
    self.classFilterView = [[ContactsClassFilterView alloc]init];
}

- (void)showFilterView {
    if (self.alertView.superview) {
        return;
    }
    self.currentClassView.isFiltering = YES;
    ContactsClassFilterView *filterView = self.classFilterView;
    [filterView reloadData];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = filterView;
    self.alertView = alert;
    CGFloat selectionViewHeight = [self.classFilterView heightForContactsClassFilterView];
    CGFloat maxHeight = SCREEN_HEIGHT - (self.tableView.y) - CGRectGetMaxY(self.navigationController.navigationBar.frame) - SafeAreaBottomHeight(self.view);
    selectionViewHeight = MIN(selectionViewHeight, maxHeight);
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [self hideFilterView];
    }];
    [alert showInView:self.view withLayout:^(AlertView *view) {
        STRONG_SELF
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentClassView.mas_bottom);
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
                make.top.equalTo(view.mas_top);
                make.height.mas_equalTo(selectionViewHeight);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [filterView setClazsFilterCompleteBlock:^(ClassListRequestItem_clazsInfos *selectClass, NSInteger selectedRow) {
        STRONG_SELF
        [alert hide];
        if (![selectClass.clazsId isEqualToString:self.selectedClass.clazsId]) {
            self.currentSelectedGroupIndex = selectedRow;
            ClassListRequestItem_clazsInfos *clazsInfo = self.totalClazsArray[selectedRow];
            self.selectedClass = clazsInfo;
            self.currentClassView.title = clazsInfo.clazsName;
            self.currentClassView.selectClassId = clazsInfo.clazsId;
            [self firstPageFetch];
        }
        [TalkingData trackEvent:@"点击聊聊切换班级"];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [headerView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.text = section ? @"学员" : @"班主任";
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsListCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.section][indexPath.row];
    cell.isLastRow = indexPath.row == [self.dataArray[indexPath.section] count] - 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GetUserInfoRequestItem_Data *data = self.dataArray[indexPath.section][indexPath.row];
//    //如果是自己则返回
//    if ([data.userId isEqualToString:[UserManager sharedInstance].userModel.userID]) {
//        //跳转我的个人资料页面
//#ifdef HuBeiApp
//        HuBeiUserInfoViewController *VC = [[HuBeiUserInfoViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//#else
//        UserInfoViewController *VC = [[UserInfoViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//#endif
//    }else{
#ifdef HuBeiApp
        HubeiContactsDetailViewController *vc = [[HubeiContactsDetailViewController alloc] init];
        vc.userId = data.userId;
        vc.fromGroupTopicId = self.selectedClass.topicId;
        [self.navigationController pushViewController:vc animated:YES];
#else
        ContactsDetailViewController *vc = [[ContactsDetailViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%@",data.userId];
        vc.fromGroupTopicId = self.selectedClass.topicId;
        [self.navigationController pushViewController:vc animated:YES];
#endif
//    }
}

@end
