//
//  OptionItemResultView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "OptionItemResultView.h"

@interface OptionItemResultView()
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
        make.bottom.mas_lessThanOrEqualTo(0);
        make.right.mas_equalTo(-20);
    }];
}

@end
