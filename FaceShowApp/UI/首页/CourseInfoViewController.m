//
//  CourseInfoViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseInfoViewController.h"
#import "CourseInfoTabContainerView.h"
#import "CourseLecturerViewController.h"
#import "CourseBriefViewController.h"

@interface CourseInfoViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@end

@implementation CourseInfoViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.type = CourseInfoType_Default;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray<NSString *> *tabArr;
    switch (self.type) {
        case CourseInfoType_Default:
        {
            self.navigationItem.title = @"课程信息";
            tabArr = @[@"讲师",@"简介"];
        }
            break;
        case CourseInfoType_NingBoMeeting:
        {
            self.navigationItem.title = @"会议信息";
            tabArr = @[@"专家",@"简介"];
        }
            break;
        default:
            break;
    }
    [self setupUIWithTabArr:tabArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUIWithTabArr:(NSArray<NSString *> *)tabArr {
    CourseInfoTabContainerView *tabContainerView = [[CourseInfoTabContainerView alloc]init];
    tabContainerView.tabNameArray = tabArr;
    WEAK_SELF
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    self.tabControllers = [NSMutableArray array];
    CourseLecturerViewController *lecVC = [[CourseLecturerViewController alloc]init];
    lecVC.lecturerInfos = self.item.data.course.lecturerInfos;
    CourseBriefViewController *briefVC = [[CourseBriefViewController alloc]init];
    briefVC.brief = self.item.data.course.briefing;
    [self.tabControllers addObject:lecVC];
    [self.tabControllers addObject:briefVC];
    for (UIViewController *vc in self.tabControllers) {
        [self addChildViewController:vc];
    }
    self.tabContentView = [[UIView alloc]init];
    [self.view addSubview:self.tabContentView];
    [self.tabContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(tabContainerView.mas_bottom);
    }];
    [self switchToVCWithIndex:0];
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

@end
