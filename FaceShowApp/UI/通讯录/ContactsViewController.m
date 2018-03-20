//
//  ContactsViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCell.h"
#import "ChatViewController.h"
#import "IMDatabaseManager.h"
#import "ContactsSearchBarView.h"
#import "ContactsCurrentClassView.h"
#import "ContactsClassFilterView.h"
#import "AlertView.h"
#import "IMConfig.h"
#import "ContactMemberContactsRequest.h"
#import "IMMember.h"

@interface ContactsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) EmptyView *emptyView;
@property(nonatomic, strong) ContactsSearchBarView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) ContactsCurrentClassView *currentClassView;
@property(nonatomic, strong) ContactsClassFilterView *classFilterView;
@property(nonatomic, strong) AlertView *alertView;

@property(nonatomic, assign) NSInteger currentSelectedGroupIndex;
@property (nonatomic, strong) NSMutableArray <ContactMemberContactsRequestItem_Data_Gcontacts_Groups *> *groupsArray;//通讯录的所有数据
@property (nonatomic, strong) NSArray <ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo *> *dataArray;//当前班级的数据
@property(nonatomic, strong) ContactMemberContactsRequest *request;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.currentSelectedGroupIndex = 0;
    self.groupsArray = [NSMutableArray array];
    self.dataArray = [NSArray array];
    self.emptyView = [[EmptyView alloc]init];
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestContacts];
    }];
    [self requestContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    WEAK_SELF
    self.searchView =  [[ContactsSearchBarView alloc]init];
    [self.searchView setSearchBlock:^(NSString *text){
        STRONG_SELF
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
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedSectionHeaderHeight = 0.f;
    self.tableView.estimatedSectionFooterHeight = 0.f;
    [self.tableView registerClass:[ContactsCell class] forCellReuseIdentifier:@"ContactsCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.currentClassView.mas_bottom);
    }];
    
    self.classFilterView = [[ContactsClassFilterView alloc]init];
}

- (void)searchContanctslWithKeyword:(NSString *)keyword {
    self.dataArray = self.groupsArray[self.currentSelectedGroupIndex].contacts;
    if (self.currentClassView.isFiltering) {
        [self.alertView hide];
    }
    if (keyword.length <= 0) {
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo *contactsInfo = self.dataArray[i];
        NSString *string = contactsInfo.memberInfo.memberName;
        if (string.length >= keyword.length) {
            if ([string rangeOfString:keyword].location != NSNotFound) {
                [resultArray addObject:contactsInfo];
            }
        }
    }
    self.dataArray = resultArray;
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
    [filterView setContactsClassFilterCompletedBlock:^(ContactMemberContactsRequestItem_Data_Gcontacts_Groups *selectedGroup, NSInteger selectedRow) {
        STRONG_SELF
        [alert hide];
        if (![selectedGroup.groupName isEqualToString:self.currentClassView.title]) {
            self.currentSelectedGroupIndex = selectedRow;
            self.currentClassView.title = selectedGroup.groupName;
            //切换相应的班级的联系人列表
            self.dataArray = self.groupsArray[selectedRow].contacts;
            //根据关键字筛选联系人
            [self searchContanctslWithKeyword:self.searchView.textField.text];
        }
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

- (void)requestContacts {
    NSString *reqId = [IMConfig generateUniqueID];
    [self.request stopRequest];
    self.request = [[ContactMemberContactsRequest alloc]init];
    self.request.reqId = reqId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[ContactMemberContactsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            return;
        }
        ContactMemberContactsRequestItem *item = (ContactMemberContactsRequestItem *)retItem;
        if (!item.data.contacts || item.data.contacts.groups.count <= 0) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            return;
        }
        [self.errorView removeFromSuperview];
        [self.emptyView removeFromSuperview];
        [self setupUI];
        ContactMemberContactsRequestItem_Data_Gcontacts *contacts = item.data.contacts;
        NSMutableArray *array = [NSMutableArray array];
        for (ContactMemberContactsRequestItem_Data_Gcontacts_Groups *group in contacts.groups) {
            [self.groupsArray addObject:group];
            self.dataArray = self.groupsArray[self.currentSelectedGroupIndex].contacts;//当前班级的数据源
            [array addObject:group];
        }
        self.classFilterView.selectedRow = self.currentSelectedGroupIndex;
        self.classFilterView.dataArray = array.copy;//班级筛选的数据
        [self.classFilterView reloadData];
        self.currentClassView.title = self.groupsArray[self.currentSelectedGroupIndex].groupName;//当前班级的名字
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.row];
    cell.isShowLine = self.dataArray.count - 1 == indexPath.row ?  NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    IMMember *member = [self.dataArray[indexPath.row] toIMMember];
    //如果是自己则返回
    GetUserInfoRequestItem_imTokenInfo *info = [UserManager sharedInstance].userModel.imInfo;
    if (member.memberID == [info.imMember toIMMember].memberID) {
        return;
    }
    NSString *groupId = self.groupsArray[self.currentSelectedGroupIndex].groupId;
    IMTopic *topic = [[IMDatabaseManager sharedInstance] findTopicWithMember:member];
    if (topic) {
        chatVC.topic = topic;
    }else {
        chatVC.member = member;
        chatVC.groupId = groupId;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)setCurrentSelectedGroupIndex:(NSInteger)currentSelectedGroupIndex {
    _currentSelectedGroupIndex = currentSelectedGroupIndex;
    self.dataArray = self.groupsArray[currentSelectedGroupIndex].contacts;
}

- (void)setDataArray:(NSArray<ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo *> *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}
@end
