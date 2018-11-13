//
//  PersonalScheduleView.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PersonalScheduleView.h"

@interface PersonalScheduleView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation PersonalScheduleView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    UIImageView *enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"] highlightedImage:[UIImage imageNamed:@"进入页面按钮点击态"]];
    [self addSubview:enterImageView];
    [enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    UIButton *b = [[UIButton alloc]init];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [RACObserve(b, highlighted) subscribeNext:^(id x) {
        STRONG_SELF
        enterImageView.highlighted = [x boolValue];
    }];

}

- (void)btnAction{
    BLOCK_EXEC(self.clickEnterBlock);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
