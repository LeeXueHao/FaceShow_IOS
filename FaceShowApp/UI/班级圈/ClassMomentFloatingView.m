//
//  ClassMomentFloatingView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentFloatingView.h"


@interface ClassMomentFloatingView ()
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation ClassMomentFloatingView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage imageNamed:@"赞icon正常态"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"赞icon-点击态"] forState:UIControlStateHighlighted];
    [self.likeButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5f, 0.0f, 2.5f);
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.likeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1a90d9"]] forState:UIControlStateHighlighted];
    [self.likeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];

    WEAK_SELF
    [[self.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentFloatingBlock,ClassMomentClickStatus_Like);
        [self removeFromSuperview];
    }];
    [self addSubview:self.likeButton];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:@"评论icon正常态"] forState:UIControlStateNormal];
    [self.commentButton setImage:[UIImage imageNamed:@"评论icon点击态"] forState:UIControlStateHighlighted];
    [self.commentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1a90d9"]] forState:UIControlStateHighlighted];
    [self.commentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5f, 0.0f, 2.5f);
    [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.commentButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];

    [[self.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentFloatingBlock,ClassMomentClickStatus_Comment);
        [self removeFromSuperview];
    }];
    [self addSubview:self.commentButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"1a90d9"];
    [self addSubview:self.lineView];
}
- (void)setupLayout {
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_height);
        make.top.equalTo(self.mas_top);
        make.width.mas_offset(80.0f);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.width.mas_offset(80.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(1.0f, 25.0f));
    }];
    
}
- (void)reloadFloatingView:(CGRect)originRect withStyle:(ClassMomentFloatingStyle)style {
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(style == ClassMomentFloatingStyle_Comment ? CGSizeMake(80.0f, 40.0f) : CGSizeMake(160.0f, 40.0f));
        make.right.equalTo(self.superview.mas_left).offset(originRect.origin.x - 10.0f);
        make.top.equalTo(self.superview.mas_top).offset(originRect.origin.y  - 5.0f);
    }];
    self.likeButton.hidden = style == ClassMomentFloatingStyle_Comment ? YES : NO;
    self.lineView.hidden = style == ClassMomentFloatingStyle_Comment ? YES : NO;
}
@end
