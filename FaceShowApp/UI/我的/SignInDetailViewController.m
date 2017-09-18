//
//  SignInDetailViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDetailViewController.h"
#import "ScanCodeViewController.h"

@interface SignInDetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeScheduleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UILabel *signedInTimeLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *signInBtn;

@end

@implementation SignInDetailViewController

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
    self.title = @"签到详情";
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(114 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *timeScheduleTitleLabel = [[UILabel alloc] init];
    timeScheduleTitleLabel.font = [UIFont systemFontOfSize:13];
    timeScheduleTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    timeScheduleTitleLabel.text = @"签到时间安排";
    [self.contentView addSubview:timeScheduleTitleLabel];
    [timeScheduleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    
    self.timeScheduleLabel = [[UILabel alloc] init];
    self.timeScheduleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.timeScheduleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.timeScheduleLabel];
    [self.timeScheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeScheduleTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *statusTitleLabel = [[UILabel alloc] init];
    statusTitleLabel.font = [UIFont systemFontOfSize:13];
    statusTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    statusTitleLabel.text = @"本次签到";
    [self.contentView addSubview:statusTitleLabel];
    [statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeScheduleLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:18];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    self.timeTitleLabel = [[UILabel alloc] init];
    self.timeTitleLabel.font = [UIFont systemFontOfSize:13];
    self.timeTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeTitleLabel.text = @"签到时间";
    [self.contentView addSubview:self.timeTitleLabel];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    
    self.signedInTimeLabel = [[UILabel alloc] init];
    self.signedInTimeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.signedInTimeLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.contentView addSubview:self.signedInTimeLabel];
    [self.signedInTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-273 * kPhoneHeightRatio);
    }];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.font = [UIFont systemFontOfSize:13];
    self.tipsLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.tipsLabel.text = @"请点击下面按钮，扫描二维码进行现场签到";
    [self.contentView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(60);
        make.centerX.mas_equalTo(0);
    }];
    
    self.signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signInBtn.clipsToBounds = YES;
    self.signInBtn.layer.cornerRadius = 7;
    self.signInBtn.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    self.signInBtn.layer.borderWidth = 2;
    [self.signInBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.signInBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    [self.signInBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.signInBtn setTitle:@"签 到" forState:UIControlStateNormal];
    [self.signInBtn addTarget:self action:@selector(signInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.signInBtn];
    [self.signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
        make.bottom.mas_equalTo(-178 * kPhoneHeightRatio);
    }];
}

- (void)signInBtnAction:(UIButton *)sender {
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

- (void)setModel {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"水电费水电费沙发斯蒂芬水电费水电费水电费水电费是打发斯蒂芬"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 27;
    style.alignment = NSTextAlignmentCenter;
    [attributedStr setAttributes:@{
                                   NSParagraphStyleAttributeName : style,
                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]
                                   } range:NSMakeRange(0, attributedStr.length)];
    self.titleLabel.attributedText = attributedStr;
    self.timeScheduleLabel.text = @"2014.8.24 8:00 - 2017.3.3 8:30";
    self.statusLabel.text = @"您还未签到";
    self.signedInTimeLabel.text = @"2017.8.8 8:00";
}

@end
