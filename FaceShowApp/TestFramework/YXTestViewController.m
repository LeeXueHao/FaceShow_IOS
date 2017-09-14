//
//  YXTestViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTestViewController.h"
#import "QuestionnaireResultViewController.h"

@interface YXTestViewController ()
@end

@implementation YXTestViewController
- (void)viewDidLoad {
    self.devTestActions = @[@"问卷结果"];
    [super viewDidLoad];
}

- (void)问卷结果 {
    QuestionnaireResultViewController *vc = [[QuestionnaireResultViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

