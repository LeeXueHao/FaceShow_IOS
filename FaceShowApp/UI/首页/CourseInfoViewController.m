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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"课程信息";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    CourseInfoTabContainerView *tabContainerView = [[CourseInfoTabContainerView alloc]init];
    tabContainerView.tabNameArray = @[@"课程讲师",@"课程简介"];
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
