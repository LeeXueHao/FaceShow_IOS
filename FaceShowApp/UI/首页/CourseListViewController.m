//
//  CourseListViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListViewController.h"
#import "CourseListCell.h"
#import "CourseListHeaderView.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "CourseDetailViewController.h"
#import "GetCourseListRequest.h"

@interface CourseListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) GetCourseListRequest *request;
@property (nonatomic, strong) GetCourseListRequestItem *requestItem;
@end

@implementation CourseListViewController

- (instancetype)initWithClazsId:(NSString *)clazsId {
    if (self = [super init]) {
        self.clazsId = clazsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCoursesInfo {
    [self.request stopRequest];
    self.request = [[GetCourseListRequest alloc]init];
    self.request.clazsId = self.clazsId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetCourseListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetCourseListRequestItem *item = (GetCourseListRequestItem *)retItem;
        if (isEmpty(item.data.courses)) {
            self.emptyView.hidden = NO;
            return;
        }
        self.requestItem = item;
        [self.tableView reloadData];
    }];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 140;
    self.tableView.sectionHeaderHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[CourseListCell class] forCellReuseIdentifier:@"CourseListCell"];
    [self.tableView registerClass:[CourseListHeaderView class] forHeaderFooterViewReuseIdentifier:@"CourseListHeaderView"];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无课程";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestCoursesInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
    [self requestCoursesInfo];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.requestItem.data.courses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[section];
    return courses.coursesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseListCell"];
    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[indexPath.section];
    cell.item = courses.coursesList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseListHeaderView"];
    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[section];
    header.title = courses.date;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc] init];
    courseDetailVC.courseId = @"";
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}


@end
