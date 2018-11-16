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
#import "ScanCodeViewController.h"
#import "UserPromptsManager.h"
#import "GetCurrentClazsRequest.h"
#import "ClassSelectionViewController.h"
#import "GetStudentClazsRequest.h"
#import "GetToolsRequest.h"
#import "ResourceDisplayViewController.h"
#import "YXDrawerController.h"
#import "MessageViewController.h"
#import "MainPageTipView.h"
#import "ScoreDetialViewController.h"
#import "GroupDetailViewController.h"
#import "GroupDetailForLeaderViewController.h"
#import "NBScheduleViewController.h"

@interface MainPageViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) GetStudentClazsRequest *clazsRefreshRequest;
@property (nonatomic, strong) MainPageTopView *topView;
@property (nonatomic, strong) MainPageTipView *tipView;
@property (nonatomic, strong) GetToolsRequest *toolsRequest;
@property (nonatomic, strong) GetToolsRequestItem *toolsItem;
@property (nonatomic, assign) CGFloat topViewHeight;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [ConfigManager sharedInstance].appName;
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    [self setupNavRightView];
    [self setupUI];
    [self requestGameInfo];
    [self setupObserver];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateClazsInfo];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.topViewHeight) {
        self.topViewHeight = CGRectGetHeight(self.topView.frame);
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.topViewHeight);
        }];
    }
}

- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 75, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"签到" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-点击态"] forState:UIControlStateHighlighted];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, -45);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self nyx_setupRightWithCustomView:navRightBtn];
}

- (void)navRightBtnAction:(UIButton *)sender {
    [TalkingData trackEvent:@"点击首页中签到"];
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.navigationItem.title = @"签到";
    scanCodeVC.isShowSignInPlace = YES;
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

- (void)setupUI {
    self.topViewHeight = 0;
    MainPageTopView *topView = [[MainPageTopView alloc]init];
    topView.item = [UserManager sharedInstance].userModel.projectClassInfo;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    WEAK_SELF
    topView.clickGroupBlock = ^(GetCurrentClazsRequestItem_userGroup *groupData) {
        STRONG_SELF
        UIViewController *vc;
        BOOL isLeader = [groupData.leaderId isEqualToString:[UserManager sharedInstance].userModel.userID];
        if (isLeader) {
            vc = [[GroupDetailForLeaderViewController alloc] init];
        }else{
            vc = [[GroupDetailViewController alloc] init];
        }
        [vc setValue:groupData forKey:@"groupData"];
//        [self.navigationController pushViewController:vc animated:YES];
    };
    self.topView = topView;
    
    self.tipView = [[MainPageTipView alloc]init];
    self.tipView.item = [UserManager sharedInstance].userModel.projectClassInfo;
    [self.tipView setSelectedTipBlock:^(GetCurrentClazsRequestItem *item) {
        STRONG_SELF
        ScoreDetialViewController *vc = [[ScoreDetialViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(50);
    }];

    MainPageTabContainerView *tabContainerView = [[MainPageTabContainerView alloc]init];
    NSArray *tabNames = @[@"课程",@"日程",@"通知",@"资源"];
    tabContainerView.tabNameArray = tabNames;
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [TalkingData trackEvent:[NSString stringWithFormat:@"点击%@", tabNames[index]]];
        self.selectedIndex = index;
        if (index == 3) {
            if (![UserPromptsManager sharedInstance].resourceNewView.hidden) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kHasNewResourceNotification object:nil];
            }
        }
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tipView.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];
    self.tabControllers = [NSMutableArray array];
    [self.tabControllers addObject:[[CourseListViewController alloc]initWithClazsId:[UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId]];
    [self.tabControllers addObject:[[ScheduleViewController alloc]init]];
//    [self.tabControllers addObject:[[NBScheduleViewController alloc] init]];
    [self.tabControllers addObject:[[MessageViewController alloc]init]];
    ResourceListViewController *resVC = [[ResourceListViewController alloc]init];
    resVC.mainVC = self;
    [self.tabControllers addObject:resVC];
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
    [self.clazsRefreshRequest stopRequest];
    self.clazsRefreshRequest = [[GetStudentClazsRequest alloc] init];
    self.clazsRefreshRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    WEAK_SELF
    [self.clazsRefreshRequest startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
        GetCurrentClazsRequestItem *item = retItem;
        self.topView.item = item;
        self.tipView.item = item;
    }];
}

#pragma mark - Game
- (void)requestGameInfo {
    [self.toolsRequest stopRequest];
    self.toolsRequest = [[GetToolsRequest alloc]init];
    self.toolsRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    WEAK_SELF
    [self.toolsRequest startRequestWithRetClass:[GetToolsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestGameInfo];
            });
            return;
        }
        [self setupGameUIWithItem:retItem];
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"kPCCodeResultBackNotification" object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.navigationController popToViewController:self animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewCertificateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        UIBarButtonItem *navItem = self.navigationItem.leftBarButtonItems.lastObject;
        UIButton *customBtn = (UIButton *)navItem.customView;
        UIView *redPointView = [[UIView alloc] init];
        redPointView.layer.cornerRadius = 4.5f;
        redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
        [customBtn.imageView addSubview:redPointView];
        [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-3.5);
            make.top.mas_equalTo(3.5);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasReadCertificateNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        UIBarButtonItem *navItem = self.navigationItem.leftBarButtonItems.lastObject;
        UIButton *customBtn = (UIButton *)navItem.customView;
        [customBtn.imageView removeSubviews];
    }];
}

- (void)setupGameUIWithItem:(GetToolsRequestItem *)item {
    self.toolsItem = item;
    if (item.data.tools.count == 0) {
        return;
    }
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.userInteractionEnabled = YES;
    imgView.animationImages = @[[UIImage imageNamed:@"按"],[UIImage imageNamed:@"按下"]];
    imgView.animationDuration = 0.2;
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-35);
        make.size.mas_equalTo(CGSizeMake(114, 102));
    }];
    [imgView startAnimating];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gameAction)];
    [imgView addGestureRecognizer:tap];
}

- (void)gameAction {
    ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc]init];
    GetToolsRequestItem_tool *tool = self.toolsItem.data.tools.firstObject;
    NSString *headUrl = tool.eventObj.content;
    NSString *classId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    NSString *token = [UserManager sharedInstance].userModel.token;
    NSString *random = [NSString stringWithFormat:@"%@",@([[NSDate date]timeIntervalSince1970])];
    NSString *url = nil;
    if ([headUrl rangeOfString:@"?"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"%@?classId=%@&token=%@&_=%@",headUrl,classId,token,random];
    }else {
        url = [NSString stringWithFormat:@"%@&classId=%@&token=%@&_=%@",headUrl,classId,token,random];
    }
    
    vc.urlString = url;
    vc.name = tool.eventObj.title;
    vc.naviBarHidden = YES;
    vc.backNormalImage = [UIImage imageNamed:@"游戏返回页面按钮正常态"];
    vc.backHighlightImage = [UIImage imageNamed:@"游戏返回页面按钮点击态"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
