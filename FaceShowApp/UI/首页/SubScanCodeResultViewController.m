//
//  SubScanCodeResultViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SubScanCodeResultViewController.h"
#import "ScanCodeViewController.h"

@interface SubScanCodeResultViewController ()
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation SubScanCodeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self nyx_setupLeftWithTitle:@"返回" action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)backAction {
    if ([self.confirmBtn.titleLabel.text isEqualToString:@"确 定"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        ScanCodeViewController *vc = [[ScanCodeViewController alloc] init];
        vc.navigationItem.title = @"签到";
        [self.navigationController pushViewController:vc animated:YES];
        NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
        [vcs removeObjectAtIndex:0];
        self.navigationController.viewControllers = vcs;
    }
}

@end
