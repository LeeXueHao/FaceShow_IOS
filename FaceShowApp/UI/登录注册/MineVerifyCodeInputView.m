//
//  MineVerifyCodeInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MineVerifyCodeInputView.h"
#import "MineInputView.h"
#import "YXGCDTimer.h"

static const NSInteger kTimerDuration = 60;

@interface MineVerifyCodeInputView()<UITextFieldDelegate>

@property (nonatomic, strong) MineInputView *inputView;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) YXGCDTimer *timer;
@property (nonatomic, assign) NSInteger secondsRemained;
@end

@implementation MineVerifyCodeInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.codeButton = [[UIButton alloc]init];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [self.codeButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.codeButton.layer.cornerRadius = 7;
    [self addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(70, 31));
    }];
//    UIView *seperatorView = [[UIView alloc]init];
//    seperatorView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
//    seperatorView.layer.cornerRadius = 1;
//    seperatorView.clipsToBounds = YES;
//    [self addSubview:seperatorView];
//    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.codeButton.mas_left);
//        make.size.mas_equalTo(CGSizeMake(2, 29));
//        make.centerY.mas_equalTo(0);
//    }];
    self.inputView = [[MineInputView alloc]init];
    self.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputView.textField.delegate = self;
    self.inputView.placeHolder = @"验证码";
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.codeButton.mas_left).mas_offset(-15);
    }];
    
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(NSString *text) {
        STRONG_SELF
        if (text.length>6) {
            self.inputView.textField.text = [text substringToIndex:6];
        }
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)btnAction {
    if (self.secondsRemained > 0) {
        return;
    }
    BLOCK_EXEC(self.sendAction);
}

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    self.codeButton.userInteractionEnabled = isActive;
    if (self.secondsRemained > 0) {
        self.codeButton.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        return;
    }
    if (isActive) {
        [self.codeButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    }else {
        [self.codeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.codeButton.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    }
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - timer
- (void)startTimer {
    if (!self.timer) {
        self.secondsRemained = kTimerDuration;
        WEAK_SELF
        self.timer = [[YXGCDTimer alloc]initWithInterval:1 repeats:YES triggerBlock:^{
            STRONG_SELF
            [self countdownTimer];
        }];
        [self.timer resume];
    }
    self.codeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
}

- (void)countdownTimer {
    if (self.secondsRemained <= 0) {
        [self stopTimer];
    } else {
        self.secondsRemained--;
        NSString *title = [NSString stringWithFormat:@"%@S",@(self.secondsRemained)];
        [self.codeButton setTitle:title forState:UIControlStateNormal];
    }
    [self setIsActive:self.secondsRemained <= 0];
}

- (void)stopTimer {
    self.timer = nil;
    self.secondsRemained = 0;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setIsActive:self.secondsRemained <= 0];
    self.codeButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (isEmpty(string) || [string nyx_isPureInt]) {
        return YES;
    }
    return NO;
}

@end
