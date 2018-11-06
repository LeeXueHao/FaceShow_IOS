//
//  DefaultLoginContainerView.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "DefaultLoginContainerView.h"

@interface DefaultLoginContainerView()
@property (nonatomic, strong) UITextField *usernameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@end

@implementation DefaultLoginContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"B5B4B9"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:14]
                                 };

    self.usernameTF = [[UITextField alloc] init];
    self.usernameTF.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.usernameTF.userInteractionEnabled = YES;
    self.usernameTF.textColor = [UIColor colorWithHexString:@"333333"];
    self.usernameTF.tintColor = [UIColor colorWithHexString:@"333333"];
    self.usernameTF.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    self.usernameTF.layer.borderWidth = 2;
    self.usernameTF.layer.cornerRadius = 6;
    NSMutableAttributedString *usernameAttrStr = [[NSMutableAttributedString alloc] initWithString:@"请输入账号" attributes:attributes];
    self.usernameTF.attributedPlaceholder = usernameAttrStr;
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    leftImageView.contentMode = UIViewContentModeCenter;
    leftImageView.image = [UIImage imageNamed:@"用户"];
    self.usernameTF.leftView = leftImageView;
    self.usernameTF.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTF.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.usernameTF];
    [self.usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(300 * kPhoneWidthRatio, 46));
    }];
    WEAK_SELF
    UIButton  *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除按钮点击态"] forState:UIControlStateHighlighted];
    [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.usernameTF.text = @"";
        deleteBtn.hidden = YES;
        [self refreshButton];
    }];
    deleteBtn.hidden = YES;
    deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.usernameTF.mas_centerY);
        make.right.mas_equalTo(self.usernameTF.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [[self.usernameTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        deleteBtn.hidden = isEmpty(self.usernameTF.text);
        [self refreshButton];
    }];

    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.userInteractionEnabled = YES;
    self.passwordTF.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.passwordTF.textColor = [UIColor colorWithHexString:@"333333"];
    self.passwordTF.tintColor = [UIColor colorWithHexString:@"333333"];
    self.passwordTF.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    self.passwordTF.layer.borderWidth = 2;
    self.passwordTF.layer.cornerRadius = 6;
    NSMutableAttributedString *passAttrStr = [[NSMutableAttributedString alloc] initWithString:@"请输入密码" attributes:attributes];
    self.passwordTF.attributedPlaceholder = passAttrStr;
    UIImageView *passleftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    passleftImage.contentMode = UIViewContentModeCenter;
    passleftImage.image = [UIImage imageNamed:@"密码"];
    self.passwordTF.leftView = passleftImage;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    self.passwordTF.rightView = rightView;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.returnKeyType = UIReturnKeyDone;
    self.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameTF.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(300 * kPhoneWidthRatio, 46));
    }];
    [[self.passwordTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshButton];
    }];
    UIButton  *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [securityBtn setBackgroundImage:[UIImage imageNamed:@"隐藏秘密正常态"] forState:UIControlStateNormal];
    [securityBtn setBackgroundImage:[UIImage imageNamed:@"隐藏秘密点击态"] forState:UIControlStateHighlighted];
    [securityBtn setBackgroundImage:[UIImage imageNamed:@"显示密码正常态"] forState:UIControlStateSelected];
    [securityBtn setBackgroundImage:[UIImage imageNamed:@"显示密码点击态"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [[securityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
        securityBtn.selected = !securityBtn.selected;
    }];
    securityBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:securityBtn];
    [securityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTF.mas_centerY);
        make.right.mas_equalTo(self.passwordTF.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];

}

- (void)refreshButton{
    if (self.usernameTF.text.length > 0 && self.passwordTF.text.length > 0) {
        BLOCK_EXEC(self.loginBtnEnabledBlock,YES);
    }else{
        BLOCK_EXEC(self.loginBtnEnabledBlock,NO);
    }
}

- (NSString *)telPhoneNumber{
    return self.usernameTF.text;
}

- (NSString *)password{
    return self.passwordTF.text;
}

- (void)clearPassWord{
    self.passwordTF.text = @"";
    [self refreshButton];
}

- (void)setFocus{
    [self.usernameTF becomeFirstResponder];
}

@end
