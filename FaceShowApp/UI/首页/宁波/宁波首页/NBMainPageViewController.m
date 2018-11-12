//
//  NBMainPageViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBMainPageViewController.h"
#import "RefreshDelegate.h"
#import "NBMainPageTopView.h"
#import "MainPageTabContainerView.h"

#import "YXDrawerController.h"
#import "ScanCodeViewController.h"
#import "MeetingListViewController.h"
#import "ScheduleViewController.h"
#import "MessageViewController.h"
#import "NBResourceListViewController.h"

#import "UserPromptsManager.h"
#import "NBConfigManager.h"

@interface NBMainPageViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) NBMainPageTopView *topView;
@end

@implementation NBMainPageViewController

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
    [self setupObserver];

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
    self.topView = [[NBMainPageTopView alloc]init];
//    topView.item = [UserManager sharedInstance].userModel.projectClassInfo;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    WEAK_SELF

    MainPageTabContainerView *tabContainerView = [[MainPageTabContainerView alloc]init];
    __block NSMutableArray *titleArr = [NSMutableArray array];
    self.tabControllers = [NSMutableArray array];
    [self.tabConf enumerateObjectsUsingBlock:^(GetClassConfigRequest_Item_tabConf  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArr addObject:obj.tabName];
        UIViewController *vc = [[NBConfigManager sharedInstance]getViewControllerWithType:obj.tabType pageConfig:nil andTabConfigArray:nil];
        [self.tabControllers addObject:vc];
        if ([vc isKindOfClass:[NBResourceListViewController class]]) {
            NBResourceListViewController *list = (NBResourceListViewController *)vc;
            list.mainVC = self;
        }
    }];
//    NSArray *tabNames = @[@"会议",@"日程",@"通知",@"资源"];
    tabContainerView.tabNameArray = titleArr;
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [TalkingData trackEvent:[NSString stringWithFormat:@"点击%@", titleArr[index]]];
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
        make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
    }];

//    [self.tabControllers addObject:[[MeetingListViewController alloc]initWithClazsId:[UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId]];
//    [self.tabControllers addObject:[[ScheduleViewController alloc]init]];
//    [self.tabControllers addObject:[[MessageViewController alloc]init]];
//    NBResourceListViewController *resVC = [[NBResourceListViewController alloc]init];
//    resVC.mainVC = self;
//    [self.tabControllers addObject:resVC];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
