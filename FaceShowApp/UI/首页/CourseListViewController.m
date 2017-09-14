//
//  CourseListViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListViewController.h"

@interface CourseListViewController ()

@end

@implementation CourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"课程";
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
    NSLog(@"refresh called!");
}

@end
