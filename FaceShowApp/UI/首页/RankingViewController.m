//
//  RankingViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "RankingViewController.h"
#import "ScroeDetailTabContainerView.h"
#import "TaskRankingViewController.h"
#import "ScoreRankingViewController.h"
#import "RefreshDelegate.h"

@interface RankingViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@end

@implementation RankingViewController

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
    [self.tabControllers addObject:[[TaskRankingViewController alloc]init]];
    [self.tabControllers addObject:[[ScoreRankingViewController alloc]init]];
    for (UIViewController *vc in self.tabControllers) {
        [self addChildViewController:vc];
    }
    self.tabContentView = [[UIView alloc]init];
    [self.view addSubview:self.tabContentView];
    [self.tabContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(tabContainerView.mas_bottom);
    }];
    
    if (self.selectedIndex) {
        if (self.selectedIndex < self.tabControllers.count) {
            [self switchToVCWithIndex:self.selectedIndex];
            tabContainerView.selectedIndex = self.selectedIndex;
        }
    }else {
        [self switchToVCWithIndex:0];
    }
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


