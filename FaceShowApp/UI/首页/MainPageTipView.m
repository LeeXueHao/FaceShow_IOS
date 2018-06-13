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
    
    self.enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"单选未选择"] highlightedImage:[UIImage imageNamed:@"单选已选择"]];
    self.enterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.enterImageView.clipsToBounds = YES;
    [self addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
   
    CGFloat x = SCREEN_WIDTH/4.0;
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.progressLabel.font = [UIFont boldSystemFontOfSize:14];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-x);
        make.centerY.mas_equalTo(0);
    }];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14];
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

//- (void)setItem:(GetCurrentClazsRequestItem *)item {
//    _item = item;
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineHeightMultiple = 1.2;
//    paraStyle.alignment = NSTextAlignmentCenter;
//    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
//    NSString *project = item.data.projectInfo.projectName;
//    NSAttributedString *projectAttributeStr = [[NSAttributedString alloc] initWithString:project attributes:dic];
//    self.progressLabel.attributedText = projectAttributeStr;
//
//    self.scoreLabel.text = item.data.clazsInfo.clazsName;
//    [self.scoreLabel sizeToFit];
//    [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.scoreLabel.width+20);
//    }];
//    [self setNeedsLayout];
//    if (self.scoreLabel.text.length == 0) {
//        self.scoreLabel.hidden = YES;
//    }
//}

@end
