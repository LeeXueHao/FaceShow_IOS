//
//  ScanPCCodeResultViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScanPCCodeResultViewController.h"

NSString * const kPCCodeResultBackNotification = @"kPCCodeResultBackNotification";

@interface ScanPCCodeResultViewController ()
@property (nonatomic, strong) UIImageView *signInImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ScanPCCodeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"登录成功";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.signInImageView = [[UIImageView alloc] init];
    self.signInImageView.image = [UIImage imageNamed:@"签到成功图标"];
    [self.view addSubview:self.signInImageView];
    [self.signInImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(95 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"成功登录网页端，可以在网页端写作业啦";
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signInImageView.mas_bottom).offset(95 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)backAction {
    [[NSNotificationCenter defaultCenter]postNotificationName:kPCCodeResultBackNotification object:nil];
}

@end
