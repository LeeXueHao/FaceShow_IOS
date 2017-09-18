//
//  AppDelegateHelper_Phone.m
//  AppDelegateTest
//
//  Created by niuzhaowang on 2016/9/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegateHelper_Phone.h"
#import "LoginViewController.h"
#import "MainPageViewController.h"
#import "MessageViewController.h"
#import "ClassMomentViewController.h"
#import "MineViewController.h"
#import "YXTestViewController.h"
#import "FSTabBarController.h"
#import "UserMessageManager.h"

@implementation AppDelegateHelper_Phone

- (UIViewController *)rootViewController{
    if ([ConfigManager sharedInstance].testFrameworkOn.boolValue) {
        return [self testViewController];
    }else if (![UserManager sharedInstance].loginStatus) {
        return [self loginViewController];
    }else {
        return [self mainViewController];
    }
}

- (UIViewController *)testViewController {
    YXTestViewController *vc = [[YXTestViewController alloc]init];
    return [[FSNavigationController alloc]initWithRootViewController:vc];
}

- (UIViewController *)loginViewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    return [[FSNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)mainViewController {
    [[UserMessageManager sharedInstance] resumeHeartbeat];
    FSTabBarController *tabBarController = [[FSTabBarController alloc] init];
    UIViewController *mainVC = [[MainPageViewController alloc]init];
    mainVC.title = @"首页";
    [self configTabbarItem:mainVC.tabBarItem image:@"" selectedImage:@""];
    FSNavigationController *mainNavi = [[FSNavigationController alloc] initWithRootViewController:mainVC];
    
    UIViewController *messageVC = [[MessageViewController alloc]init];
    messageVC.title = @"消息";
    [self configTabbarItem:messageVC.tabBarItem image:@"" selectedImage:@""];
    FSNavigationController *messageNavi = [[FSNavigationController alloc] initWithRootViewController:messageVC];
    messageNavi.tabBarItem.badgeValue = @"";
    
    UIViewController *classVC = [[ClassMomentViewController alloc]init];
    classVC.title = @"班级圈";
    [self configTabbarItem:classVC.tabBarItem image:@"" selectedImage:@""];
    FSNavigationController *classNavi = [[FSNavigationController alloc] initWithRootViewController:classVC];
    
    UIViewController *mineVC = [[MineViewController alloc]init];
    mineVC.title = @"我的";
    [self configTabbarItem:mineVC.tabBarItem image:@"" selectedImage:@""];
    FSNavigationController *mineNavi = [[FSNavigationController alloc] initWithRootViewController:mineVC];
    
    tabBarController.viewControllers = @[mainNavi, messageNavi, classNavi, mineNavi];
    return tabBarController;
}

- (void)configTabbarItem:(UITabBarItem *)tabBarItem image:(NSString *)image selectedImage:(NSString *)selectedImage {
    tabBarItem.image = [UIImage imageNamed:image];
    tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"b28f47"]} forState:UIControlStateSelected];
}

#pragma mark -
- (void)handleLoginSuccess {
    self.window.rootViewController = [self mainViewController];
    [[UserMessageManager sharedInstance] resumeHeartbeat];
}

- (void)handleLogoutSuccess {
    [self.window.rootViewController presentViewController:[self loginViewController] animated:YES completion:nil];
    [[UserMessageManager sharedInstance] suspendHeartbeat];
}


@end
