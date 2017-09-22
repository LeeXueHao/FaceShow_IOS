//
//  ErrorView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"网络异常插画"];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.65);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];

    UILabel *label = [[UILabel alloc]init];
    label.text = @"无网络数据，请立即刷新";
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    UIButton *refreshButton = [[UIButton alloc]init];
    [refreshButton setTitle:@"立即刷新" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    refreshButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    refreshButton.clipsToBounds = YES;
    refreshButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    refreshButton.layer.borderWidth = 2;
    refreshButton.layer.cornerRadius = 7;
    [refreshButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.retryBlock);
}

@end
