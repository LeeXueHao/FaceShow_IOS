//
//  CourseDetailViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "ErrorView.h"
#import "CourseDetailHeaderView.h"
#import "CourseCatalogCell.h"
#import "CourseBriefViewController.h"
#import "ProfessorDetailViewController.h"
#import "GetCourseRequest.h"

@interface CourseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CourseDetailHeaderView *headerView;
@property (nonatomic, strong) GetCourseRequest *request;
@property (nonatomic, strong) GetCourseRequestItem_Course *course;
@property (nonatomic, strong) NSMutableArray<NSArray *> *dataArray;
@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupCourseData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setupCourseData {
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request stopRequest];
    self.request = [[GetCourseRequest alloc] init];
    self.request.courseId = self.courseId;
    [self.request startRequestWithRetClass:[GetCourseRequestItem class] andCompleteBlock:^(GetCourseRequestItem *retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.course = retItem.data.course;
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:!isEmpty(self.course.lecturerInfos) ? self.course.lecturerInfos : [NSArray array]];
        [self.dataArray addObject:!isEmpty(self.course.attachmentInfos) ? self.course.attachmentInfos : [NSArray array]];
        [self.dataArray addObject:!isEmpty(self.course.interactSteps) ? self.course.interactSteps : [NSArray array]];
        self.tableView.hidden = NO;
        self.headerView.course = self.course;
        [self.tableView layoutIfNeeded];
        [self.tableView reloadData];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.errorView = [[ErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self setupCourseData];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.headerView = [[CourseDetailHeaderView alloc] init];
    self.headerView.viewAllBlock = ^{
        STRONG_SELF
        CourseBriefViewController *courseBriefVC = [[CourseBriefViewController alloc] init];
        courseBriefVC.courseBrief = self.course.briefing;
        [self.navigationController pushViewController:courseBriefVC animated:NO];
    };
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.tableView registerClass:[CourseCatalogCell class] forCellReuseIdentifier:@"CourseCatalogCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.hidden = YES;

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor greenColor];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(self.view.mas_top).offset(42);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogCell"];
    if (indexPath.section == 0) {
        GetCourseRequestItem_LecturerInfo *info = self.dataArray[0][indexPath.row];
        cell.title = info.lecturerName;
        cell.iconUrl = info.lecturerAvatar;
    } else if (indexPath.section == 1) {
        GetCourseRequestItem_AttachmentInfo *info = self.dataArray[1][indexPath.row];
        cell.title = info.resName;
        cell.iconUrl = info.resThumb;
    } else if (indexPath.section == 2) {
        GetCourseRequestItem_InteractStep *info = self.dataArray[2][indexPath.row];
        cell.title = info.interactName;
//        cell.iconUrl = info.
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GetCourseRequestItem_LecturerInfo *info = self.dataArray[0][indexPath.row];
        ProfessorDetailViewController *professorDetailVC = [[ProfessorDetailViewController alloc] init];
        professorDetailVC.lecturerInfo = info;
        [self.navigationController pushViewController:professorDetailVC animated:NO];
    } else if (indexPath.section == 1) {
        GetCourseRequestItem_AttachmentInfo *info = self.dataArray[1][indexPath.row];
        
    } else if (indexPath.section == 2) {
        GetCourseRequestItem_InteractStep *info = self.dataArray[2][indexPath.row];
        
    }
}

@end
