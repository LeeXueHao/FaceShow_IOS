//
//  ApnsQuestionnaireViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ApnsQuestionnaireViewController.h"
#import "ApnsQuestionnaireResultViewController.h"

@interface ApnsQuestionnaireViewController ()

@end

@implementation ApnsQuestionnaireViewController

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

- (void)goVoteResult {
    ApnsQuestionnaireResultViewController *vc = [[ApnsQuestionnaireResultViewController alloc]initWithStepId:self.stepId];
    vc.name = self.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goQuestionnaireResult {
    ApnsQuestionnaireViewController *vc = [[ApnsQuestionnaireViewController alloc]initWithStepId:self.stepId interactType:self.interactType];
    vc.name = self.name;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
