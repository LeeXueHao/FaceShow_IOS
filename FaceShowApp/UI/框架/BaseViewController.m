//
//  BaseViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "PageNameMappingTable.h"
#import "YXDrawerController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            WEAK_SELF
            [self nyx_setupLeftWithImageName:@"返回页面按钮正常态-" highlightImageName:@"返回页面按钮点击态" action:^{
                STRONG_SELF
                [self backAction];
            }];
        }
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    NSString *vcName = NSStringFromClass([self class]);
    NSString *pageName = [PageNameMappingTable pageNameForViewControllerName:vcName];
    if (pageName) {
        [TalkingData trackPageEnd:pageName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL navHidden = self.navigationController.isNavigationBarHidden;
    [self.navigationController setNavigationBarHidden:navHidden animated:YES];
    NSString *vcName = NSStringFromClass([self class]);
    NSString *pageName = [PageNameMappingTable pageNameForViewControllerName:vcName];
    if (pageName) {
        [TalkingData trackPageBegin:pageName];
    }
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UINavigationController *)navigationController{
    UINavigationController *navi = [super navigationController];
    if (!navi) {
        YXDrawerViewController *drawerVC = [YXDrawerController drawer];
        if ([drawerVC.paneViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarVC = (UITabBarController *)drawerVC.paneViewController;
            navi = tabBarVC.viewControllers[tabBarVC.selectedIndex];
        }
    }
    return navi;
}

@end
