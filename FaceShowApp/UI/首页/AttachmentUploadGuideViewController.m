//
//  AttachmentUploadGuideViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AttachmentUploadGuideViewController.h"
#import "ScanPCCodeViewController.h"

@interface AttachmentUploadGuideViewController ()

@end

@implementation AttachmentUploadGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"上传附件";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    UILabel *step1Label = [[UILabel alloc]init];
    step1Label.text = @"第一步";
    step1Label.textColor = [UIColor colorWithHexString:@"999999"];
    step1Label.font = [UIFont boldSystemFontOfSize:13];
    step1Label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:step1Label];
    [step1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLine.mas_bottom).mas_offset(80);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *step1ContentLabel = [[UILabel alloc]init];
    step1ContentLabel.text = @"用电脑浏览器打开网址";
    step1ContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    step1ContentLabel.font = [UIFont boldSystemFontOfSize:14];
    step1ContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:step1ContentLabel];
    [step1ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step1Label.mas_bottom).mas_offset(8);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *urlLabel = [[UILabel alloc]init];
    urlLabel.text = [ConfigManager sharedInstance].pcAddress;
    urlLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    urlLabel.font = [UIFont boldSystemFontOfSize:18];
    urlLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step1ContentLabel.mas_bottom).mas_offset(35);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *step2Label = [step1Label clone];
    step2Label.text = @"第二步";
    [self.contentView addSubview:step2Label];
    [step2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(urlLabel.mas_bottom).mas_offset(35);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *step2ContentLabel = [step1ContentLabel clone];
    step2ContentLabel.text = @"扫描二维码登录，完成作业";
    [self.contentView addSubview:step2ContentLabel];
    [step2ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step2Label.mas_bottom).mas_offset(8);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *scanLabel = [[UILabel alloc]init];
    scanLabel.text = @"打开网址后，点击扫码按钮";
    scanLabel.textColor = [UIColor colorWithHexString:@"999999"];
    scanLabel.font = [UIFont systemFontOfSize:13];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:scanLabel];
    [scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step2ContentLabel.mas_bottom).mas_offset(60);
        make.left.right.mas_equalTo(0);
    }];
    UIButton *scanButton = [[UIButton alloc]init];
    [scanButton setTitle:@"扫 码" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    scanButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    scanButton.layer.borderWidth = 2;
    scanButton.layer.cornerRadius = 7;
    WEAK_SELF
    [[scanButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        ScanPCCodeViewController *vc = [[ScanPCCodeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.contentView addSubview:scanButton];
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scanLabel.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
        make.bottom.mas_equalTo(-40);
    }];
}

@end
