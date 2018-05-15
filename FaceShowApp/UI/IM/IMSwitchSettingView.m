//
//  IMSwitchSettingView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMSwitchSettingView.h"

@interface IMSwitchSettingView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation IMSwitchSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
    }];
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel.textColor = [UIColor colorWithHexString:@"999999"];
    descLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-15);
    }];
    self.switchView = [[UISwitch alloc]init];
    self.switchView.onTintColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.switchView addTarget:self action:@selector(stateChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.titleLabel = titleLabel;
    self.descLabel = descLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    self.descLabel.text = desc;
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    self.switchView.on = isOn;
}

- (void)stateChange:(UISwitch *)sender {
    BLOCK_EXEC(self.stateChangeBlock,sender.isOn);
}

@end
