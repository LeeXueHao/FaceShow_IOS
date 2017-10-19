//
//  ApnsCourseDetailViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ApnsCourseDetailViewController.h"

@interface ApnsCourseDetailViewController ()

@end

@implementation ApnsCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"返回页面按钮正常态-" highlightImageName:@"返回页面按钮点击态" action:^{
        STRONG_SELF
        [self backAction];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
