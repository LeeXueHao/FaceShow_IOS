//
//  NBLiveViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBLiveViewController.h"
#import "NBLiveDetailViewController.h"
#import "FSTabBarController.h"

@implementation NBLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NBLiveDetailViewController *detail = [[NBLiveDetailViewController alloc] init];
    detail.webUrl = self.pageConf.url;
    WEAK_SELF
    detail.backBlock = ^{
        STRONG_SELF
        FSTabBarController *tabbar = (FSTabBarController *)self.tabBarController;
        [self.tabBarController setSelectedIndex:tabbar.lastSelectIndex];
    };
    [self.navigationController pushViewController:detail animated:YES];
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
