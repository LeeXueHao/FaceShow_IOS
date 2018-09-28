//
//  ResourceDownloadMethodTwoView.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ResourceDownloadMethodTwoView.h"

@implementation ResourceDownloadMethodTwoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"方法二：扫码登录下载";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(22);
    }];

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 6;
    [self insertSubview:backgroundView belowSubview:titleLabel];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(titleLabel).offset(-7);
        make.right.bottom.mas_equalTo(titleLabel).offset(7);
    }];

    UILabel *step1Label = [[UILabel alloc]init];
    step1Label.text = @"第一步";
    step1Label.textColor = [UIColor colorWithHexString:@"999999"];
    step1Label.font = [UIFont boldSystemFontOfSize:13];
    step1Label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:step1Label];
    [step1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(17);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *step1ContentLabel = [[UILabel alloc]init];
    step1ContentLabel.text = @"用电脑浏览器打开网址";
    step1ContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    step1ContentLabel.font = [UIFont boldSystemFontOfSize:14];
    step1ContentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:step1ContentLabel];
    [step1ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step1Label.mas_bottom).mas_offset(8);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *urlLabel = [[UILabel alloc]init];
    urlLabel.text = [ConfigManager sharedInstance].pcAddress;
    urlLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    urlLabel.font = [UIFont boldSystemFontOfSize:14];
    urlLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step1ContentLabel.mas_bottom).mas_offset(35);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *step2Label = [step1Label clone];
    step2Label.text = @"第二步";
    [self addSubview:step2Label];
    [step2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(urlLabel.mas_bottom).mas_offset(35);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *step2ContentLabel = [step1ContentLabel clone];
    step2ContentLabel.text = @"扫描二维码登录，完成作业";
    [self addSubview:step2ContentLabel];
    [step2ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(step2Label.mas_bottom).mas_offset(8);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *scanLabel = [[UILabel alloc]init];
    scanLabel.text = @"打开网址后，点击扫码按钮";
    scanLabel.textColor = [UIColor colorWithHexString:@"999999"];
    scanLabel.font = [UIFont systemFontOfSize:13];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:scanLabel];
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
        BLOCK_EXEC(self.scanBlock);
    }];
    [self addSubview:scanButton];
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scanLabel.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
        make.bottom.mas_equalTo(-40);
    }];
}

@end
