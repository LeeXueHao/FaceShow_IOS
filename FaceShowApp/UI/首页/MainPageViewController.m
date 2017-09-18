//
//  MainPageViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageViewController.h"
#import "QuestionnaireViewController.h"
#import "MainPageTopView.h"
#import "MainPageTabContainerView.h"
#import "RefreshDelegate.h"
#import "CourseListViewController.h"
#import "ResourceListViewController.h"
#import "ScheduleViewController.h"
#import "TaskListViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "ScanCodeViewController.h"

@interface MainPageViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"扫一扫" action:^{
        STRONG_SELF
        ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
        [self.navigationController pushViewController:scanCodeVC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    MainPageTopView *topView = [[MainPageTopView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    MainPageTabContainerView *tabContainerView = [[MainPageTabContainerView alloc]init];
    tabContainerView.tabNameArray = @[@"课程",@"资源",@"任务",@"日程"];
    WEAK_SELF
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    self.tabControllers = [NSMutableArray array];
    [self.tabControllers addObject:[[CourseListViewController alloc]init]];
    [self.tabControllers addObject:[[ResourceListViewController alloc]init]];
    [self.tabControllers addObject:[[TaskListViewController alloc]init]];
    [self.tabControllers addObject:[[ScheduleViewController alloc]init]];
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
    
    self.emptyView = [[EmptyView alloc]init];
//    self.emptyView.title = @"暂无课程";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
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
    SAFE_CALL(self.tabControllers[index], refreshUI);
}


@end
