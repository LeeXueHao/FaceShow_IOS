//
//  AboutItemView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AboutItemView.h"

@interface AboutItemView()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation AboutItemView

- (instancetype)initWithItemName:(NSString *)itemName{
    self = [super init];
    if (self) {
        _title = itemName;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.backgroundColor = [UIColor whiteColor];

    UIImageView *enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"] highlightedImage:[UIImage imageNamed:@"进入页面按钮点击态"]];
    [self addSubview:enterImageView];
    [enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];


    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"323941"];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(enterImageView.mas_left).offset(-15);
    }];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(1);
    }];

    UIButton *b = [[UIButton alloc]init];
    [self addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [RACObserve(b, highlighted) subscribeNext:^(id x) {
        STRONG_SELF
        enterImageView.highlighted = [x boolValue];
    }];

    [[b rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.clickBlock);
    }];
    
}

-(void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    [self.lineView setHidden:!showLine];
}

@end
