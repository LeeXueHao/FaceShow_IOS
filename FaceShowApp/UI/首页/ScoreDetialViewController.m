//
//  ScoreDetialViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreDetialViewController.h"
#import "ScroeDetailTabContainerView.h"
#import "TaskScoreViewController.h"
#import "StudyScoreViewController.h"
#import "RefreshDelegate.h"

@interface ScoreDetialViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;

@end

@implementation ScoreDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {

    ScroeDetailTabContainerView *tabContainerView = [[ScroeDetailTabContainerView alloc]init];
    NSArray *tabNames = @[@"任务进度",@"学习积分"];
    tabContainerView.tabNameArray = tabNames;
    WEAK_SELF
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
//        [TalkingData trackEvent:[NSString stringWithFormat:@"点击%@", tabNames[index]]];
        self.selectedIndex = index;
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    self.tabControllers = [NSMutableArray array];
    [self.tabControllers addObject:[[TaskScoreViewController alloc]init]];
    [self.tabControllers addObject:[[StudyScoreViewController alloc]init]];
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

- (void)updateClazsInfo {
//    [self.clazsRefreshRequest stopRequest];
//    self.clazsRefreshRequest = [[GetStudentClazsRequest alloc] init];
//    self.clazsRefreshRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
//    WEAK_SELF
//    [self.clazsRefreshRequest startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
//        STRONG_SELF
//        if (error) {
//            return;
//        }
//        GetCurrentClazsRequestItem *item = retItem;
//        self.topView.item = item;
//    }];
}


@end

