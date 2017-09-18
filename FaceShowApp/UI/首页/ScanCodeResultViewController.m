//
//  ScanCodeResultViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScanCodeResultViewController.h"

@interface ScanCodeResultViewController ()

@property (nonatomic, strong) UIImageView *signInImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *blackLabel;
@property (nonatomic, strong) UILabel *grayLabel;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ScanCodeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.title = @"签到";
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.signInImageView = [[UIImageView alloc] init];
    self.signInImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.signInImageView];
    [self.signInImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(95 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signInImageView.mas_bottom).offset(9);
        make.centerX.mas_equalTo(0);
    }];
    
    self.blackLabel = [[UILabel alloc] init];
    self.blackLabel.font = [UIFont systemFontOfSize:14];
    self.blackLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.blackLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.blackLabel];
    [self.blackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(40);
        make.centerX.mas_equalTo(0);
    }];
    
    self.grayLabel = [[UILabel alloc] init];
    self.grayLabel.font = [UIFont systemFontOfSize:13];
    self.grayLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.grayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.grayLabel];
    [self.grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blackLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(0);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.clipsToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 7;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    self.confirmBtn.layer.borderWidth = 2;
    [self.confirmBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.grayLabel.mas_bottom).offset(50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
    }];
}

- (void)setModel {
    self.titleLabel.text = @"签到失败";
    self.blackLabel.text = @"签到二维码已过期";
    self.grayLabel.text = @"请扫描最新二维码";
    [self.confirmBtn setTitle:@"重新签到" forState:UIControlStateNormal];
}

@end
