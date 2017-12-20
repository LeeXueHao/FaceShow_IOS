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
#import "ScanCodeViewController.h"
#import "UserPromptsManager.h"

@interface MainPageViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavRightView];
    [self setupUI];
}

- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 75, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"签到" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-点击态"] forState:UIControlStateHighlighted];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 24);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 38, 0, -38);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self nyx_setupRightWithCustomView:navRightBtn];
}

- (void)navRightBtnAction:(UIButton *)sender {
    [TalkingData trackEvent:@"点击首页中签到"];
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

- (void)setupUI {
    MainPageTopView *topView = [[MainPageTopView alloc]init];
    topView.item = [UserManager sharedInstance].userModel.projectClassInfo;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    MainPageTabContainerView *tabContainerView = [[MainPageTabContainerView alloc]init];
    NSArray *tabNames = @[@"课程",@"资源",@"任务",@"日程"];
    tabContainerView.tabNameArray = tabNames;
    WEAK_SELF
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [TalkingData trackEvent:[NSString stringWithFormat:@"点击%@", tabNames[index]]];
        self.selectedIndex = index;
        if (index == 1) {
            [UserPromptsManager sharedInstance].resourceNewView.hidden = YES;
        }
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    self.tabControllers = [NSMutableArray array];
    [self.tabControllers addObject:[[CourseListViewController alloc]initWithClazsId:[UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId]];
    ResourceListViewController *resVC = [[ResourceListViewController alloc]init];
    resVC.mainVC = self;
    [self.tabControllers addObject:resVC];
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
