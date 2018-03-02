//
//  CourseDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "GetCourseRequest.h"
#import "ErrorView.h"
#import "CourseDetailTabContainerView.h"
#import "CourseTaskViewController.h"
#import "CourseResourceViewController.h"
#import "CourseInfoViewController.h"

@interface CourseDetailViewController ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetCourseRequest *request;
@property (nonatomic, strong) GetCourseRequestItem *requestItem;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupCourseData];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回页面按钮正常态-"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回页面按钮点击态"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.centerY.mas_equalTo(self.view.mas_top).offset(42);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setupUI {
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.image = [UIImage imageNamed:@"课程详情头图"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:21];
    titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    titleLabel.text = @"课 l 程 l 详 l 情";
    [self.headerImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-45);
        make.centerX.mas_equalTo(0);
    }];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImageView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 650));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 2;
    [scrollView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(18);
    }];
    UILabel *timeTagLabel = [[UILabel alloc]init];
    timeTagLabel.font = [UIFont systemFontOfSize:11];
    timeTagLabel.textColor = [UIColor whiteColor];
    timeTagLabel.textAlignment = NSTextAlignmentCenter;
    timeTagLabel.backgroundColor = [UIColor colorWithHexString:@"979fad"];
    timeTagLabel.text = @"时间";
    timeTagLabel.layer.cornerRadius = 3;
    timeTagLabel.clipsToBounds = YES;
    [scrollView addSubview:timeTagLabel];
    [timeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(19);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [scrollView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(timeTagLabel.mas_centerY);
    }];
    UILabel *teacherTagLabel = [timeTagLabel clone];
    teacherTagLabel.text = @"讲师";
    [scrollView addSubview:teacherTagLabel];
    [teacherTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_left);
        make.top.mas_equalTo(timeTagLabel.mas_bottom).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.teacherLabel = [self.timeLabel clone];
    [scrollView addSubview:self.teacherLabel];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(teacherTagLabel.mas_centerY);
    }];
    UILabel *placeTagLabel = [timeTagLabel clone];
    placeTagLabel.text = @"地点";
    [scrollView addSubview:placeTagLabel];
    [placeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherTagLabel.mas_left);
        make.top.mas_equalTo(teacherTagLabel.mas_bottom).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.placeLabel = [self.timeLabel clone];
    [scrollView addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(placeTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(placeTagLabel.mas_centerY);
    }];
    UIButton *courseInfoButton = [[UIButton alloc]init];
    [courseInfoButton setTitle:@"课程信息" forState:UIControlStateNormal];
    [courseInfoButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [courseInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [courseInfoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    courseInfoButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [courseInfoButton addTarget:self action:@selector(courseInfoAction) forControlEvents:UIControlEventTouchUpInside];
    courseInfoButton.layer.cornerRadius = 6;
    courseInfoButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    courseInfoButton.layer.borderWidth = 1;
    courseInfoButton.clipsToBounds = YES;
    [scrollView addSubview:courseInfoButton];
    [courseInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.placeLabel.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [scrollView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(courseInfoButton.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(5);
    }];
    CourseDetailTabContainerView *tabContainerView = [[CourseDetailTabContainerView alloc]init];
    tabContainerView.tabNameArray = @[@"课程任务",@"课程资源"];
    WEAK_SELF
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [self switchToVCWithIndex:index];
    }];
    [scrollView addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(sepView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    self.tabControllers = [NSMutableArray array];
    CourseTaskViewController *taskVC = [[CourseTaskViewController alloc]init];
    CourseResourceViewController *resourceVC = [[CourseResourceViewController alloc]init];
    [self.tabControllers addObject:taskVC];
    [self.tabControllers addObject:resourceVC];
    for (UIViewController *vc in self.tabControllers) {
        [self addChildViewController:vc];
    }
    self.tabContentView = [[UIView alloc]init];
    [scrollView addSubview:self.tabContentView];
    [self.tabContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(tabContainerView.mas_bottom);
    }];
    [self switchToVCWithIndex:0];
    
    self.errorView = [[ErrorView alloc] init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self setupCourseData];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)courseInfoAction {
    [TalkingData trackEvent:@"查看课程简介"];
    CourseInfoViewController *vc = [[CourseInfoViewController alloc]init];
    vc.item = self.requestItem;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchToVCWithIndex:(NSInteger)index {
    for (UIView *v in self.tabContentView.subviews) {
        [v removeFromSuperview];
    }
    UIView *v = self.tabControllers[index].view;
    [self.tabContentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        [self refreshUIWithItem:retItem];
    }];
}

- (void)refreshUIWithItem:(GetCourseRequestItem *)item {
    self.requestItem = item;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *project = item.data.course.courseName;
    NSAttributedString *projectAttributeStr = [[NSAttributedString alloc] initWithString:project attributes:dic];
    self.titleLabel.attributedText = projectAttributeStr;
    
    NSArray *startArr = [item.data.course.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *startTime = startArr.lastObject;
    startTime = [startTime substringToIndex:5];
    NSArray *endArr = [item.data.course.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = endArr.lastObject;
    endTime = [endTime substringToIndex:5];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",startDate,startTime,endDate,endTime];
    
    NSString *lectureName = @"暂无";
    NSMutableArray *lecArray = [NSMutableArray array];
    for (GetCourseRequestItem_LecturerInfo *info in item.data.course.lecturerInfos) {
        [lecArray addObject:info.lecturerName];
    }
    if (lecArray.count > 0) {
        lectureName = [lecArray componentsJoinedByString:@","];
    }
    self.teacherLabel.text = lectureName;
    self.placeLabel.text = isEmpty(item.data.course.site) ? @"待定" : item.data.course.site;
    
    CourseTaskViewController *taskVc = (CourseTaskViewController *)self.tabControllers.firstObject;
    taskVc.interactSteps = item.data.interactSteps;
    CourseResourceViewController *resourceVc = (CourseResourceViewController *)self.tabControllers.lastObject;
    resourceVc.attachmentInfos = item.data.course.attachmentInfos;
}


@end
