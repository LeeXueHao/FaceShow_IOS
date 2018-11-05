//
//  YXInputView.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXInputView.h"

@interface YXInputView()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *usernameTF;
@property (nonatomic, strong) UITextField *passwordTF;

@property (nonatomic, readwrite, assign) YXInputViewType type;

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

    self.type = YXInputViewType_Default;

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
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

    UIView *defaultContainer = [[UIView alloc] init];
    [containerView addSubview:defaultContainer];
    [defaultContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
    }];

    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"B5B4B9"],
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                 };

    self.usernameTF = [[UITextField alloc] init];
    self.usernameTF.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.usernameTF.textColor = [UIColor colorWithHexString:@"333333"];
    self.usernameTF.tintColor = [UIColor colorWithHexString:@"333333"];
    self.usernameTF.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    self.usernameTF.layer.borderWidth = 2;
    self.usernameTF.layer.cornerRadius = 6;
    NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc] initWithString:@"请输入账号"];
    [attributedStr2 setAttributes:attributes range:NSMakeRange(0, attributedStr2.length)];
    self.usernameTF.attributedPlaceholder = attributedStr2;
    self.usernameTF.defaultTextAttributes = attributes;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"用户"]];
    self.usernameTF.leftView = leftImageView;
    self.usernameTF.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTF.returnKeyType = UIReturnKeyDone;
    self.usernameTF.delegate = self;
    [defaultContainer addSubview:self.usernameTF];
    [self.usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.passwordTF.mas_top).offset(-10);
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
    }];
    deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [defaultContainer addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.usernameTF.mas_centerY);
        make.right.mas_equalTo(self.usernameTF.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];

    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.passwordTF.textColor = [UIColor colorWithHexString:@"333333"];
    self.passwordTF.tintColor = [UIColor colorWithHexString:@"333333"];
    self.passwordTF.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    self.passwordTF.layer.borderWidth = 2;
    self.passwordTF.layer.cornerRadius = 6;
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    [attributedStr1 setAttributes:attributes range:NSMakeRange(0, attributedStr1.length)];
    self.passwordTF.attributedPlaceholder = attributedStr1;
    self.passwordTF.defaultTextAttributes = attributes;
    UIImageView *passleftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码"]];
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
//    leftView.backgroundColor = [UIColor clearColor];
    self.passwordTF.leftView = passleftImage;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    self.passwordTF.rightView = rightView;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.returnKeyType = UIReturnKeyDone;
    self.passwordTF.delegate = self;
    self.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    [defaultContainer addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameTF.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(300 * kPhoneWidthRatio, 46));
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
    [defaultContainer addSubview:securityBtn];
    [securityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTF.mas_centerY);
        make.right.mas_equalTo(self.passwordTF.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];





    UIView *quickContainer = [[UIView alloc] init];
    [containerView addSubview:quickContainer];
    [quickContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
    }];




}



//- (void)setType:(YXInputViewType)type{
//    _type = type;
//    switch (type) {
//        case YXInputViewType_Default:
//        {
//
//        }
//            break;
//        case YXInputViewType_QuickLogin:
//        {
//
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}


@end
