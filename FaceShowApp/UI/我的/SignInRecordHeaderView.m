//
//  SignInRecordHeaderView.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInRecordHeaderView.h"

@interface SignInRecordHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *classLabel;

@end

@implementation SignInRecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setModel];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(19);
        make.centerX.mas_equalTo(0);
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.font = [UIFont boldSystemFontOfSize:14];
    self.classLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.classLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)setModel {
    self.titleLabel.text = @"水电费水电费水电费是";
    self.classLabel.text = @"19号一班";
}

@end
