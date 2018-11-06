//
//  QuickLoginContainerView.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QuickLoginContainerView.h"
#import "MinePhoneInputView.h"
#import "MineVerifyCodeInputView.h"

@interface QuickLoginContainerView()
@property (nonatomic, strong) MinePhoneInputView *accountView;
@property (nonatomic, strong) MineVerifyCodeInputView *verifyCodeView;
@end

@implementation QuickLoginContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    CGFloat leftMargin = ([UIScreen mainScreen].bounds.size.width - 300 * kPhoneWidthRatio)/2;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"B5B4B9"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:14]
                                 };
    UIImageView *accountLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    accountLeftImage.image = [UIImage imageNamed:@"手机"];
    accountLeftImage.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    accountLeftImage.contentMode = UIViewContentModeCenter;
    [self addSubview:accountLeftImage];
    [accountLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(leftMargin);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];

    self.accountView = [[MinePhoneInputView alloc]init];
    self.accountView.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    NSMutableAttributedString *accountAttrStr = [[NSMutableAttributedString alloc] initWithString:@"请输入账号" attributes:attributes];
    self.accountView.inputView.textField.attributedPlaceholder = accountAttrStr;
    WEAK_SELF
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        if (self.accountView.text.length>11) {
            self.accountView.inputView.textField.text = [self.accountView.text substringToIndex:11];
        }
        self.verifyCodeView.isActive = self.accountView.text.length > 0;
        [self refreshButton];
    }];
    [self addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountLeftImage.mas_right).offset(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(300 * kPhoneWidthRatio - 46 + 15, 46));
    }];

    UIImageView *verifyLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    verifyLeftImage.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    verifyLeftImage.image = [UIImage imageNamed:@"验证码"];
    verifyLeftImage.contentMode = UIViewContentModeCenter;
    [self addSubview:verifyLeftImage];
    [verifyLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).offset(20);
        make.left.mas_equalTo(leftMargin);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    self.verifyCodeView = [[MineVerifyCodeInputView alloc]init];
    self.verifyCodeView.isActive = NO;
    [self.verifyCodeView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshButton];
    }];
    [self.verifyCodeView setSendAction:^{
        STRONG_SELF
        BLOCK_EXEC(self.verifyCodeBlock,self.accountView.text);
    }];
    [self addSubview:self.verifyCodeView];
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).offset(20);
        make.left.mas_equalTo(verifyLeftImage.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(300 * kPhoneWidthRatio - 46 + 15, 46));
    }];

    self.accountView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.verifyCodeView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];

}

- (void)refreshButton{
    if (self.accountView.text.length > 0 && self.verifyCodeView.text.length > 0) {
        BLOCK_EXEC(self.loginBtnEnabledBlock,YES);
    }else{
        BLOCK_EXEC(self.loginBtnEnabledBlock,NO);
    }
}

- (NSString *)telPhoneNumber{
    return self.accountView.text;
}

- (NSString *)password{
    return self.verifyCodeView.text;
}

- (void)startTimer{
    [self.verifyCodeView startTimer];
}

- (void)stopTimer{
    [self.verifyCodeView stopTimer];
}

- (void)setFocus{
    [self.accountView.inputView.textField becomeFirstResponder];
}
@end
