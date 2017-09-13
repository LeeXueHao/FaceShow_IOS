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
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"页面加载失败插图"];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(250*kPhoneWidthRatio);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"页面加载失败...";
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
    }];
    UIButton *refreshButton = [[UIButton alloc]init];
    [refreshButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [refreshButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    refreshButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    refreshButton.clipsToBounds = YES;
    refreshButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    refreshButton.layer.borderWidth = 2;
    refreshButton.layer.cornerRadius = 6;
    [refreshButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(55);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(125, 40));
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.retryBlock);
}

@end
