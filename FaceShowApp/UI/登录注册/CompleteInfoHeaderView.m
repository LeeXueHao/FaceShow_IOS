//
//  CompleteInfoHeaderView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CompleteInfoHeaderView.h"

@interface CompleteInfoHeaderView ()
@property (nonatomic, strong) UILabel *promptLabel;
@end

@implementation CompleteInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    self.promptLabel = [[UILabel alloc]init];
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    self.promptLabel.font = [UIFont systemFontOfSize:13];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *message = @"您的手机号为研修网账号，可直接使用对应的密码登录，如果不记得了，可使用忘记密码功能进行设置。";
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:message attributes:dic];
    self.promptLabel.attributedText = attributeStr;
    [bgView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
}

- (CGFloat)properHeight {
    CGSize size = [self.promptLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, 999)];
    return ceil(size.height) + 20 + 10;
}

@end

