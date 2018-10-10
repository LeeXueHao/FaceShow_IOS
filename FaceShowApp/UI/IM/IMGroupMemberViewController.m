//
//  IMGroupMemberViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/10/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMGroupMemberViewController.h"
#import "GetContactRequest.h"
#import "ContactsCell.h"
#import "ErrorView.h"
#import "EmptyView.h"
#import "ChatViewController.h"
#import "IMUserInterface.h"
#import "IMTopicInfoItem.h"
#import "ContactsSearchBarView.h"
#import "ContactMemberContactsRequest.h"

@interface IMGroupMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ContactsSearchBarView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GetContactRequest *request;
@property (nonatomic, strong) GetContactRequestItem_Data_Gcontacts_Groups *group;
@property (nonatomic, strong) NSArray <GetContactRequestItem_Data_Gcontacts_ContactsInfo *> *totalArray;//当前班级的所有数据
@property (nonatomic, strong) NSArray <GetContactRequestItem_Data_Gcontacts_ContactsInfo *> *dataArray;//当前班级的数据
@end

@implementation IMGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群成员";
    self.emptyView = [[EmptyView alloc]init];
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestContact];
    }];
    [self requestContact];
}

- (void)requestContact{
    [self.request stopRequest];
    self.request = [[GetContactRequest alloc] init];
    self.request.topicId = self.topicId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetContactRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            return;
        }
        GetContactRequestItem *item = (GetContactRequestItem *)retItem;
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
        self.group = item.data.contacts.groups.firstObject;
        self.totalArray = self.group.contacts;
        self.dataArray = self.group.contacts;
    }];
}

- (void)showErroView {
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
}

#pragma mark - setupUI
- (void)setupUI {
    WEAK_SELF
    self.searchView =  [[ContactsSearchBarView alloc]init];
    [self.searchView setSearchBlock:^(NSString *text){
        STRONG_SELF
        [self searchContactsWithKeyWords:text];
        [TalkingData trackEvent:@"点击聊聊搜索框"];
    }];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.mas_equalTo(0).offset(10);
        }
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(34);
    }];

    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ContactsCell class] forCellReuseIdentifier:@"ContactsCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(10);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.row];
    cell.isShowLine = !(indexPath.row == [self.dataArray count] - 1);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GetContactRequestItem_Data_Gcontacts_ContactsInfo *data = self.dataArray[indexPath.row];
    [self startChatWithData:data];
}

- (void)startChatWithData:(GetContactRequestItem_Data_Gcontacts_ContactsInfo *)data {
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    IMMember *member = [data toIMMember];
    //如果是自己则返回
    GetUserInfoRequestItem_imTokenInfo *info = [UserManager sharedInstance].userModel.imInfo;
    if (member.memberID == [info.imMember toIMMember].memberID) {
        return;
    }
    IMTopic *topic = [IMUserInterface findTopicWithMember:member];
    if (topic) {
        chatVC.topic = topic;
    }else {
        IMTopicInfoItem *item = [[IMTopicInfoItem alloc]init];
        item.member = member;
        ContactMemberContactsRequestItem_Data_Gcontacts_Groups *group = [[ContactMemberContactsRequestItem_Data_Gcontacts_Groups alloc] init];
        group.groupId = self.group.groupId;
        group.groupName = self.group.groupName;
        item.group = group;
        chatVC.info = item;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)searchContactsWithKeyWords:(NSString *)keyword{
    if (keyword.length <= 0) {
        self.dataArray = [self.totalArray mutableCopy];
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray array];
    [self.totalArray enumerateObjectsUsingBlock:^(GetContactRequestItem_Data_Gcontacts_ContactsInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = obj.memberInfo.memberName;
        if (string.length >= keyword.length) {
            if ([string rangeOfString:keyword].location != NSNotFound) {
                [resultArray addObject:obj];
            }
        }
    }];
    self.dataArray = resultArray;
}

- (void)setDataArray:(NSArray<GetContactRequestItem_Data_Gcontacts_ContactsInfo *> *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end
