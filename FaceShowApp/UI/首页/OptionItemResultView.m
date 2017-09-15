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
    self.optionLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.optionLabel.font = [UIFont systemFontOfSize:15];
    self.optionLabel.numberOfLines = 0;
    [self addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
    UIView *resultContainerView = [[UIView alloc]init];
    [self addSubview:resultContainerView];
    [resultContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.optionLabel.mas_left);
        make.right.mas_equalTo(self.optionLabel.mas_right);
        make.top.mas_equalTo(self.optionLabel.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    self.resultContainerView = resultContainerView;
    
    self.resultView = [[UIView alloc]init];
    self.resultView.backgroundColor = [UIColor purpleColor];
    [resultContainerView addSubview:self.resultView];
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
}

@end
