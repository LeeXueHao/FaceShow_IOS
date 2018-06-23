//
//  MainPageTipView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MainPageTipView.h"

@interface MainPageTipView()
@property (nonatomic, strong) UIImageView *enterImageView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@end

@implementation MainPageTipView

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
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.progressLabel.font = [UIFont boldSystemFontOfSize:15];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-x);
        make.centerY.mas_equalTo(0);
    }];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:15];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        self.enterImageView.highlighted = [x boolValue];
    }];
}

- (void)butonAction:(UIButton *)sender {
    BLOCK_EXEC(self.selectedTipBlock,self.item);
}

- (void)setupMock {
    NSString *progress = @"任务进度  79%";
    NSMutableAttributedString *progressAttStr = [[NSMutableAttributedString alloc]initWithString:progress];
    [progressAttStr addAttributes:@{NSFontAttributeName:self.progressLabel.font,NSForegroundColorAttributeName:self.progressLabel.textColor} range:NSMakeRange(0,[progress length])];
    [progressAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1da1f2"] range:NSMakeRange(5, [progress length] - 5)];
    self.progressLabel.attributedText = progressAttStr;
    
    NSString *score = @"学习积分  79";
    NSMutableAttributedString *scoreAttStr = [[NSMutableAttributedString alloc]initWithString:score];
    [scoreAttStr addAttributes:@{NSFontAttributeName:self.progressLabel.font,NSForegroundColorAttributeName:self.progressLabel.textColor} range:NSMakeRange(0,[score length])];
    [scoreAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1da1f2"] range:NSMakeRange(5, [score length] - 5)];
    self.scoreLabel.attributedText = scoreAttStr;
}

- (void)setItem:(GetCurrentClazsRequestItem *)item {
    _item = item;
    float task = [item.data.taskCompletion floatValue] * 100;
    NSString *progressStr = [NSString stringWithFormat:@"%@",@(task)];
    if ([progressStr containsString:@"."]) {
        progressStr = [NSString stringWithFormat:@"%.2f%@",[progressStr floatValue],@"%"];
    }else {
        progressStr = [NSString stringWithFormat:@"%.0f%@",[progressStr floatValue],@"%"];
    }
    progressStr = [NSString stringWithFormat:@"任务进度  %@",progressStr];
    NSMutableAttributedString *progressAttStr = [[NSMutableAttributedString alloc]initWithString:progressStr];
    [progressAttStr addAttributes:@{NSFontAttributeName:self.progressLabel.font,NSForegroundColorAttributeName:self.progressLabel.textColor} range:NSMakeRange(0,[progressStr length])];
    [progressAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1da1f2"] range:NSMakeRange(5, [progressStr length] - 5)];
    self.progressLabel.attributedText = progressAttStr;
    
    NSString *score = [NSString stringWithFormat:@"学习积分  %.0f",[item.data.userScore floatValue]];
    NSMutableAttributedString *scoreAttStr = [[NSMutableAttributedString alloc]initWithString:score];
    [scoreAttStr addAttributes:@{NSFontAttributeName:self.progressLabel.font,NSForegroundColorAttributeName:self.progressLabel.textColor} range:NSMakeRange(0,[score length])];
    [scoreAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1da1f2"] range:NSMakeRange(5, [score length] - 5)];
    self.scoreLabel.attributedText = scoreAttStr;
}

@end
