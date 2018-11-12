//
//  MeetingListViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingListViewController.h"
#import "MeetingListCell.h"
#import "CourseListHeaderView.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "NBGetMeetingListRequest.h"

@interface MeetingListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NBGetMeetingListRequest *request;
@property (nonatomic, strong) NBGetMeetingListRequestItem *requestItem;
@end

@implementation MeetingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)requestMeetingInfo{
    [self.request stopRequest];
    [self.view nyx_startLoading];
    self.request = [[NBGetMeetingListRequest alloc] init];
    self.request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[NBGetMeetingListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        NBGetMeetingListRequestItem *item = (NBGetMeetingListRequestItem *)retItem;
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
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[MeetingListCell class] forCellReuseIdentifier:@"MeetingListCell"];
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
        [self requestMeetingInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
    [self requestMeetingInfo];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.requestItem.data.courses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NBGetMeetingListRequestItem_Courses *courses = self.requestItem.data.courses[section];
    return courses.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NBGetMeetingListRequestItem_Courses *courses = self.requestItem.data.courses[indexPath.section];
    NBGetMeetingListRequestItem_Group *group = courses.group[indexPath.row];
    MeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingListCell"];
    cell.group = group;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBGetMeetingListRequestItem_Courses *courses = self.requestItem.data.courses.firstObject;
    NBGetMeetingListRequestItem_Group *group = courses.group[indexPath.section];
    return group.cellHeight + 97;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseListHeaderView"];
    NBGetMeetingListRequestItem_Courses *courses = self.requestItem.data.courses[section];
    header.title = courses.date;
    if (courses.isToday.boolValue) {
        header.title = [NSString stringWithFormat:@"%@ 今日课程",courses.date];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc] init];
//    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[indexPath.section];
//    GetCourseListRequestItem_coursesList *course = courses.coursesList[indexPath.row];
//    courseDetailVC.courseId = course.courseId;
//    [self.navigationController pushViewController:courseDetailVC animated:YES];
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
