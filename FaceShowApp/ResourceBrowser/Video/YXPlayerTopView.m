//
//  YXPlayerTopView.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXPlayerTopView.h"

@interface YXPlayerTopView()
@property (nonatomic, strong) UIView *sep0;
@property (nonatomic, strong) UIView *sep2;
@end

@implementation YXPlayerTopView
- (id)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    //self.backgroundColor = [[UIColor colorWithHexString:@"#1f1f1f"] colorWithAlphaComponent:0.2];
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"播放器返回"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"返回按钮-点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.backButton];
    
    UIView *sep0 = [[UIView alloc] init];
    _sep0 = sep0;
    sep0.backgroundColor = [UIColor colorWithHexString:@"#5e5e5e"];
    [self addSubview:sep0];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.titleLabel];

    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forwardButton setImage:[UIImage imageNamed:@"播放器forward"] forState:UIControlStateNormal];
    [self.forwardButton setImage:[UIImage imageNamed:@"播放器forward2"] forState:UIControlStateHighlighted];
    [self addSubview:self.forwardButton];
    
    UIView *sep1 = [[UIView alloc] init];
    sep1.backgroundColor = [UIColor colorWithHexString:@"#5e5e5e"];
    [self addSubview:sep1];
    
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadButton setImage:[UIImage imageNamed:@"播放器download"] forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"播放器download2"] forState:UIControlStateHighlighted];
    [self addSubview:self.downloadButton];
    
    UIView *sep2 = [[UIView alloc] init];
    _sep2 = sep2;
    sep2.backgroundColor = [UIColor colorWithHexString:@"#5e5e5e"];
    [self addSubview:sep2];
    
    self.favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorButton setImage:[UIImage imageNamed:@"播放器favor"] forState:UIControlStateNormal];
    [self.favorButton setImage:[UIImage imageNamed:@"播放器favor2"] forState:UIControlStateHighlighted];
    [self addSubview:self.favorButton];
    
    UIView *sep3 = [[UIView alloc] init];
    sep3.backgroundColor = [UIColor colorWithHexString:@"#5e5e5e"];
    [self addSubview:sep3];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage imageNamed:@"播放器like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"播放器like2"] forState:UIControlStateHighlighted];
    [self addSubview:self.likeButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0f);
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        make.left.mas_equalTo(5.0f);
    }];
    
    [sep0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(1/[UIScreen mainScreen].scale, 11));
        make.left.mas_equalTo(self.mas_left).offset(50.0f);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.top.bottom.mas_equalTo (@0);
        make.left.mas_equalTo(sep0.mas_right).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(@-90.0f);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.mas_equalTo(@0);
    }];
    
    [sep3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(1/[UIScreen mainScreen].scale, 16));
        make.right.mas_equalTo(self.likeButton.mas_left);
    }];
    
    [self.favorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.mas_equalTo(sep3.mas_left);
    }];
    
    [sep2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(1/[UIScreen mainScreen].scale, 16));
        make.right.mas_equalTo(self.mas_right).offset(-50.0f);
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.mas_equalTo(sep2.mas_left);
    }];
    
    [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(1/[UIScreen mainScreen].scale, 16));
        make.right.mas_equalTo(self.downloadButton.mas_left);
    }];
    
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.mas_equalTo(sep1.mas_left);
    }];
    
    sep1.hidden = YES;
    sep2.hidden = YES;
    sep3.hidden = YES;
    self.downloadButton.hidden = YES;
    self.forwardButton.hidden = YES;
    self.likeButton.hidden = YES;
    self.favorButton.hidden = YES;
}

- (void)setPreviewFavorButton:(UIButton *)previewFavorButton{
    _previewFavorButton = previewFavorButton;
    if (previewFavorButton) {
        _sep2.hidden = NO;
        [self addSubview:previewFavorButton];
        [previewFavorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
            make.right.equalTo(self.mas_right).offset(-5);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(@0);
            make.top.bottom.mas_equalTo (@0);
            make.left.mas_equalTo(self.sep0.mas_right).mas_offset(15);
            make.right.lessThanOrEqualTo(previewFavorButton.mas_left).offset(-15);
        }];
    }
}

@end
