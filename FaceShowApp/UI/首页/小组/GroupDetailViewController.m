//
//  GroupDetailViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "GroupMemberCell.h"
#import "GroupDetailByStudentRequest.h"
@interface GroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) GroupDetailByStudentRequest *detailRequest;
@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.groupData.groupName;
    [self setupUI];
    [self requestStudentsData];
}

- (void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.estimatedSectionHeaderHeight = 44;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GroupMemberCell class] forCellReuseIdentifier:@"GroupMemberCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无资源";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestStudentsData];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;

}

- (void)requestStudentsData{
    [self.detailRequest stopRequest];
    [self.view nyx_startLoading];
    self.detailRequest = [[GroupDetailByStudentRequest alloc] init];
    self.detailRequest.groupId = self.groupData.groupId;
    WEAK_SELF
    [self.detailRequest startRequestWithRetClass:[GroupDetailByStudentRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GroupDetailByStudentRequest_Item *item = (GroupDetailByStudentRequest_Item *)retItem;
        if (item.data.group.students.count == 0 && !item.data.group.leader) {
            self.emptyView.hidden = NO;
            return;
        }
        NSArray *leaderArr;
        NSMutableArray *dataArray = [NSMutableArray array];
        if (item.data.group.leader) {
            leaderArr = [NSArray arrayWithObject:item.data.group.leader];
            [dataArray addObject:leaderArr];
        }
        NSArray *studentsArr = [NSArray arrayWithArray:item.data.group.students];
        [dataArray addObject:studentsArr];
        self.dataArray = [NSArray arrayWithArray:dataArray];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberCell"];
    NSArray *arr = self.dataArray[indexPath.section];
    cell.students = arr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    if (self.dataArray.count == 2) {
        [label setText:section?@"组员":@"组长"];
    }else{
        [label setText:@"组员"];
    }
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    return view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
