//
//  YXInputView.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXInputView.h"
#import "QuickLoginContainerView.h"
#import "DefaultLoginContainerView.h"

@interface YXInputView()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DefaultLoginContainerView *defaultContainerView;
@property (nonatomic, strong) QuickLoginContainerView *quickContainerView;


@end

@implementation YXInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.type = YXInputViewType_QuickLogin;

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).multipliedBy(2.0f);
        make.height.mas_equalTo(self.scrollView);
    }];

    self.quickContainerView = [[QuickLoginContainerView alloc] init];
    WEAK_SELF
    self.quickContainerView.verifyCodeBlock = ^(NSString * _Nonnull telPhoneNumber) {
        STRONG_SELF
        BLOCK_EXEC(self.sendVerifyCodeBlock,telPhoneNumber);
    };
    self.quickContainerView.loginBtnEnabledBlock = ^(BOOL btnEnabled) {
        STRONG_SELF
        BLOCK_EXEC(self.btnEnabledBlock,btnEnabled);
    };
    [containerView addSubview:self.quickContainerView];
    [self.quickContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
    }];

    self.defaultContainerView = [[DefaultLoginContainerView alloc] init];
    self.defaultContainerView.loginBtnEnabledBlock = ^(BOOL btnEnabled) {
        STRONG_SELF
        BLOCK_EXEC(self.btnEnabledBlock,btnEnabled);
    };
    [containerView addSubview:self.defaultContainerView];
    [self.defaultContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
    }];


}

- (void)setType:(YXInputViewType)type{
    _type = type;
    self.scrollView.scrollEnabled = YES;
    if (type == YXInputViewType_Default) {
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        [self.defaultContainerView refreshButton];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.quickContainerView refreshButton];
    }
    self.scrollView.scrollEnabled = NO;
}

- (NSString *)telPhoneNumber{
    if (_type == YXInputViewType_Default) {
        return self.defaultContainerView.telPhoneNumber;
    }else{
        return self.quickContainerView.telPhoneNumber;
    }
}

- (NSString *)password{
    if(_type == YXInputViewType_QuickLogin){
        return self.quickContainerView.password;
    }else{
        return self.defaultContainerView.password;
    }
}

- (void)startTimer{
    [self.quickContainerView startTimer];
}

- (void)stopTimer{
    [self.quickContainerView stopTimer];
}

- (void)clearPassWord{
    [self.defaultContainerView clearPassWord];
}

- (void)setFocus{
    if(_type == YXInputViewType_QuickLogin){
        [self.quickContainerView setFocus];
    }else{
        [self.defaultContainerView setFocus];
    }
}

@end
