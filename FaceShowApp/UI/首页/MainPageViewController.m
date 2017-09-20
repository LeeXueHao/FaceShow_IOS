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
#import "GetCurrentClazsRequest.h"

@interface MainPageViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetCurrentClazsRequest *request;
@property (nonatomic, strong) GetCurrentClazsRequestItem *requestItem;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavRightView];
    [self requestProjectClassInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 75, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"签到" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [navRightBtn setImage:[[UIImage imageNamed:@"登录背景"] nyx_aspectFillImageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -37, 0, 37);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, -37);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self nyx_setupRightWithCustomView:navRightBtn];
}

- (void)navRightBtnAction:(UIButton *)sender {
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

- (void)requestProjectClassInfo {
    [self.request stopRequest];
    self.request = [[GetCurrentClazsRequest alloc]init];
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetCurrentClazsRequestItem *item = (GetCurrentClazsRequestItem *)retItem;
        if (!item.data.projectInfo) {
            self.emptyView.hidden = NO;
            return;
        }
        self.requestItem = item;
        [self setupUI];
    }];
}

- (void)setupUI {
    MainPageTopView *topView = [[MainPageTopView alloc]init];
    topView.item = self.requestItem;
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
    [self.tabControllers addObject:[[CourseListViewController alloc]initWithClazsId:self.requestItem.data.clazsInfo.clazsId]];
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
        [self requestProjectClassInfo];
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
