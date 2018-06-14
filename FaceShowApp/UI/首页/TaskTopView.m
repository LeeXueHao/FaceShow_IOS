//
//  TaskTopView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskTopView.h"

@interface TaskTopView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) UIImageView *enterImageView;

@end

@implementation TaskTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupMock];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"单选未选择"] highlightedImage:[UIImage imageNamed:@"单选已选择"]];
    self.enterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.enterImageView.clipsToBounds = YES;
    [self addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(0);
    }];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:45];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.centerX.mas_equalTo(0);
    }];
    
    self.rankingLabel = [[UILabel alloc]init];
    self.rankingLabel.font = [UIFont systemFontOfSize:12];
    self.rankingLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.rankingLabel];
    [self.rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scoreLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
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
        self.enterImageView.highlighted = [x boolValue];
    }];
}

- (void)butonAction:(UIButton *)sender {
    BLOCK_EXEC(self.rankingChoosedBlock);
}

- (void)setupMock {
    self.titleLabel.text = @"任务完成率";
    self.scoreLabel.text = @"80%";
    NSString *ranking = @"班级排名:第六名";
    NSMutableAttributedString *rankingAttStr = [[NSMutableAttributedString alloc]initWithString:ranking];
    [rankingAttStr addAttributes:@{NSFontAttributeName:self.rankingLabel.font,NSForegroundColorAttributeName:self.rankingLabel.textColor} range:NSMakeRange(0,[ranking length])];
    [rankingAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1da1f2"] range:NSMakeRange(5, [ranking length] - 5)];
    self.rankingLabel.attributedText = rankingAttStr;
}

@end
