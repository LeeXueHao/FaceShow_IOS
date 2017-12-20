//
//  FSTabBarController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FSTabBarController.h"
#import "UserPromptsManager.h"

@interface FSTabBarController ()<UITabBarControllerDelegate>

@end

@implementation FSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return [self topViewController].shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self topViewController].supportedInterfaceOrientations;
}

- (UIViewController *)topViewController {
    UINavigationController *navi = self.selectedViewController;
    if ([navi isKindOfClass:[UINavigationController class]]) {
        return navi.topViewController;
    }
    return navi;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.selectedIndex == 2) {
        [UserPromptsManager sharedInstance].momentNewView.hidden = NO;
    }
}

@end
