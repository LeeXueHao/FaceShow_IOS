//
//  CertificateHeaderView.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CertificateHeaderView.h"

@implementation CertificateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.backgroundColor = [UIColor lightGrayColor];

    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    label.text = @"终极一班证书";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
    }];


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
