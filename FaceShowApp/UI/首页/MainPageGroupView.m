//
//  MainPageGroupView.m
//  FaceShowApp
//
//  Created by SRT on 2018/10/18.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MainPageGroupView.h"

@interface MainPageGroupView()
@property (nonatomic, strong) UIImageView *enterImageView;
@property (nonatomic, strong) UILabel *groupNameLabel;
@end

@implementation MainPageGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.backgroundColor = [UIColor whiteColor];

    self.enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"] highlightedImage:[UIImage imageNamed:@"进入页面按钮点击态"]];
    self.enterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.enterImageView.clipsToBounds = YES;
    [self addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    CGFloat x = SCREEN_WIDTH/4.0;

    UIButton *myGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myGroupButton setImage:[UIImage imageNamed:@"分组签到"] forState:UIControlStateNormal];
    [myGroupButton setTitle:@"我的小组" forState:UIControlStateNormal];
    myGroupButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [myGroupButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self addSubview:myGroupButton];
    [myGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(-x);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];

    self.groupNameLabel = [[UILabel alloc] init];
    self.groupNameLabel.text = @"第一小组";
    self.groupNameLabel.font = [UIFont boldSystemFontOfSize:15];
    self.groupNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.groupNameLabel];
    [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(x);
        make.centerY.mas_equalTo(0);
    }];

    UIButton *button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(butonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [RACObserve(button, highlighted) subscribeNext:^(id x) {
        STRONG_SELF
//        self.enterImageView.highlighted = [x boolValue];
    }];

}

- (void)setGroupName:(NSString *)groupName{
    _groupName = groupName;
    [self.groupNameLabel setText:groupName];
}

- (void)butonAction:(UIButton *)sender{
    
}

@end
