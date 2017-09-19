//
//  OptionItemResultView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "OptionItemResultView.h"

@implementation OptionResult

@end

@interface OptionItemResultView()
@property (nonatomic, strong) UIView *resultContainerView;
@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UILabel *optionLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation OptionItemResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.optionLabel = [[UILabel alloc]init];
    self.optionLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.optionLabel.font = [UIFont systemFontOfSize:14];
    self.optionLabel.numberOfLines = 0;
    [self addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-52);
    }];
    UIView *resultContainerView = [[UIView alloc]init];
    resultContainerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    resultContainerView.layer.cornerRadius = 3;
    resultContainerView.clipsToBounds = YES;
    [self addSubview:resultContainerView];
    [resultContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.optionLabel.mas_left);
        make.right.mas_equalTo(-52);
        make.top.mas_equalTo(self.optionLabel.mas_bottom).mas_offset(7);
        make.bottom.mas_equalTo(-2);
        make.height.mas_equalTo(6);
    }];
    self.resultContainerView = resultContainerView;
    
    self.resultView = [[UIView alloc]init];
    self.resultView.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    self.resultView.layer.cornerRadius = 3;
    self.resultView.clipsToBounds = YES;
    [resultContainerView addSubview:self.resultView];
    
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(resultContainerView.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(resultContainerView.mas_centerY);
    }];
}

- (void)setOption:(OptionResult *)option {
    _option = option;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:option.option attributes:dic];
    self.optionLabel.attributedText = attributeStr;
    [self.resultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.resultContainerView.mas_width).multipliedBy(option.rate);
    }];
    
    self.countLabel.text = @"15";
}

@end
