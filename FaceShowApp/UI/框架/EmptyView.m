//
//  EmptyView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/8/1.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"空插画-"];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.75);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"无内容";
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];

    self.topImageView = topImageView;
    self.descLabel = label;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title yx_isValidString]) {
        self.descLabel.text = title;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.topImageView.image = image;
}

@end
