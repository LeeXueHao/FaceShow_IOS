//
//  MeetingListViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MeetingListViewController.h"
#import "MeetingListCell.h"
#import "MeetingListHeaderView.h"
#import "EmptyView.h"
#import "ErrorView.h"

@interface MeetingListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSString *clazsId;
@end

@implementation MeetingListViewController

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

- (void)requestMeetingInfo{

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
    [self.tableView registerClass:[MeetingListCell class] forCellReuseIdentifier:@"MeetingListCell"];
    [self.tableView registerClass:[MeetingListHeaderView class] forHeaderFooterViewReuseIdentifier:@"MeetingListHeaderView"];

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
//    return self.requestItem.data.courses.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[section];
//    return courses.coursesList.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingListCell"];
//    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[indexPath.section];
//    cell.item = courses.coursesList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MeetingListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MeetingListHeaderView"];
//    GetCourseListRequestItem_courses *courses = self.requestItem.data.courses[section];
//    header.title = courses.date;
//    if (courses.isToday.boolValue) {
//        header.title = [NSString stringWithFormat:@"%@ 今日课程",courses.date];
//    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
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
