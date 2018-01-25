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
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *oneLineView;
@property (nonatomic, strong) UIView *twoLineView;

@property (nonatomic, assign) ClassMomentFloatingStyle floatingStyle;
@end
@implementation ClassMomentFloatingView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage imageNamed:@"赞icon正常态"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"赞icon点击态"] forState:UIControlStateHighlighted];
    [self.likeButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5f, 0.0f, 2.5f);
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.likeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0059b3"]] forState:UIControlStateHighlighted];
    
    WEAK_SELF
    [[self.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if ([[self.likeButton titleForState:UIControlStateNormal] isEqualToString:@"赞"]) {
            BLOCK_EXEC(self.classMomentFloatingBlock,ClassMomentClickStatus_Like);
        }else {
            BLOCK_EXEC(self.classMomentFloatingBlock,ClassMomentClickStatus_Cancel);
        }
        [self removeFromSuperview];
    }];
    [self addSubview:self.likeButton];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setImage:[UIImage imageNamed:@"评论icon正常态"] forState:UIControlStateNormal];
    [self.commentButton setImage:[UIImage imageNamed:@"评论icon点击态"] forState:UIControlStateHighlighted];
    [self.commentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    [self.commentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0059b3"]] forState:UIControlStateHighlighted];
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
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"班级圈删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"班级圈删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0059b3"]] forState:UIControlStateHighlighted];
    self.deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5f, 0.0f, 2.5f);
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentFloatingBlock,ClassMomentClickStatus_Delete);
        [self removeFromSuperview];
    }];
    [self addSubview:self.deleteButton];
    
    self.oneLineView = [[UIView alloc] init];
    self.oneLineView.backgroundColor = [UIColor colorWithHexString:@"1a90d9"];
    [self addSubview:self.oneLineView];
    
    self.twoLineView = [[UIView alloc] init];
    self.twoLineView.backgroundColor = [UIColor colorWithHexString:@"1a90d9"];
    [self addSubview:self.twoLineView];
}
- (void)setupLayoutFloatingStyle:(ClassMomentFloatingStyle)floatingStyle {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeConstraints:obj.constraints];
        [obj removeFromSuperview];
        
    }];
    if ((floatingStyle == (ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Cancel | ClassMomentFloatingStyle_Delete)) || (floatingStyle == (ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Like | ClassMomentFloatingStyle_Delete))) {
        [self addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.width.mas_offset(80.0f);
        }];
        [self addSubview:self.likeButton];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_offset(80.0f);
        }];
        [self addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.width.mas_offset(80.0f);
        }];
        [self addSubview:self.oneLineView];
        [self.oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_offset(CGSizeMake(1.0f, 25.0f));
            make.left.equalTo(self.deleteButton.mas_right);
        }];
        
        [self addSubview:self.twoLineView];
        [self.twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_offset(CGSizeMake(1.0f, 25.0f));
            make.right.equalTo(self.commentButton.mas_left);
        }];
    }else {
        [self addSubview:self.likeButton];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.width.mas_offset(80.0f);
        }];
        [self addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.width.mas_offset(80.0f);
        }];
        [self addSubview:self.oneLineView];
        [self.oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_offset(CGSizeMake(1.0f, 25.0f));
        }];
    }
}
- (void)reloadFloatingView:(CGRect)originRect withStyle:(ClassMomentFloatingStyle)style {
    [self setupLayoutFloatingStyle:style];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(2.0f);
        make.height.mas_offset(40.0f);
        make.right.equalTo(self.superview.mas_left).offset(originRect.origin.x - 10.0f);
        make.top.equalTo(self.superview.mas_top).offset(originRect.origin.y  - 5.0f);
    }];
    CGFloat widthFloat = 80.0f;
    if (style == (ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Cancel | ClassMomentFloatingStyle_Delete)) {
        [self.likeButton setTitle:@"取消" forState:UIControlStateNormal];
         widthFloat = 240.0f;
        self.oneLineView.hidden = NO;
        self.twoLineView.hidden = NO;
    }else if (style == (ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Like | ClassMomentFloatingStyle_Delete)) {
        [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
        widthFloat = 240.0f;
        self.oneLineView.hidden = NO;
        self.twoLineView.hidden = NO;
    }else if (style == (ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Cancel)) {
        [self.likeButton setTitle:@"取消" forState:UIControlStateNormal];
        widthFloat = 160.0f;
        self.oneLineView.hidden = NO;
        self.twoLineView.hidden = YES;
    }else if (style == (ClassMomentFloatingStyle_Comment | ClassMomentFloatingStyle_Like)) {
        [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
        widthFloat = 160.0f;
        self.oneLineView.hidden = NO;
        self.twoLineView.hidden = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(widthFloat);
            }];
            [self.superview layoutIfNeeded];
        }];
    });
}
- (void)hiddenViewAnimate:(BOOL)animate {
    if (animate) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2f animations:^{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_offset(2.0f);
                }];
                [self.superview layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
    }else {
        [self removeFromSuperview];
    }
}

@end
