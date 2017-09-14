//
//  OptionItemView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "OptionItemView.h"

@interface OptionItemView()
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *optionLabel;
@end

@implementation OptionItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectButton = [[UIButton alloc]init];
    [self.selectButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    self.optionLabel = [[UILabel alloc]init];
    self.optionLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.optionLabel.font = [UIFont systemFontOfSize:15];
    self.optionLabel.numberOfLines = 0;
    [self addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).mas_offset(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_lessThanOrEqualTo(0);
        make.right.mas_equalTo(-20);
    }];
}

- (void)btnAction {
    self.selectButton.selected = !self.selectButton.selected;
    BLOCK_EXEC(self.clickBlock,self);
}

- (BOOL)isSelected {
    return self.selectButton.selected;
}

- (void)setIsSelected:(BOOL)isSelected {
    self.selectButton.selected = isSelected;
}

- (void)setOption:(NSString *)option {
    _option = option;
    self.optionLabel.text = option;
}

@end
