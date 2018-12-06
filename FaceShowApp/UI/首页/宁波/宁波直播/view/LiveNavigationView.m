//
//  LiveNavigationView.m
//  FaceShowApp
//
//  Created by SRT on 2018/12/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "LiveNavigationView.h"

@interface LiveNavigationView()

@property (nonatomic, strong) UIButton *forwardBtn;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation LiveNavigationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    CGFloat positionX = SCREEN_WIDTH * 3/16;
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-positionX);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    WEAK_SELF
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.backActionBlock);
    }];

    self.forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forwardBtn setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [self addSubview:self.forwardBtn];
    [self.forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(positionX);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.forwardBtn setEnabled:NO];
    [[self.forwardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.forwardActionBlock);
    }];
}

- (void)refreshForwardEnabled:(BOOL)forwardEnabled backEnabled:(BOOL)backEnabled{
    [self.forwardBtn setEnabled:forwardEnabled];
    [self.backBtn setEnabled:backEnabled];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
