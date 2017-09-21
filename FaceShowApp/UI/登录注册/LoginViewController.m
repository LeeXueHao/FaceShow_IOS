//
//  LoginViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginDataManager.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - setupUI
- (void)setupUI {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录背景"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.layer.cornerRadius = 6;
    self.loginBtn.clipsToBounds = YES;
    [self.loginBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage yx_createImageWithColor:[[UIColor colorWithHexString:@"ffffff"] colorWithAlphaComponent:.7f]] forState:UIControlStateDisabled];
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-80);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250, 40));
    }];
    
    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    self.passwordTF.layer.borderWidth = 2;
    self.passwordTF.layer.cornerRadius = 6;
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"ffffff"],
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                 };
    [attributedStr1 setAttributes:attributes range:NSMakeRange(0, attributedStr1.length)];
    self.passwordTF.attributedPlaceholder = attributedStr1;
    self.passwordTF.defaultTextAttributes = attributes;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    self.passwordTF.leftView = leftView;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    self.passwordTF.rightView = rightView;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.returnKeyType = UIReturnKeyDone;
    self.passwordTF.delegate = self;
    [self.contentView addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.loginBtn.mas_top).offset(-20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250, 40));
    }];
    
    UIButton  *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    securityBtn.backgroundColor = [UIColor redColor];
    [securityBtn addTarget:self action:@selector(securityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:securityBtn];
    [securityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTF.mas_centerY);
        make.right.mas_equalTo(self.passwordTF.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];

    self.usernameTF = [[UITextField alloc] init];
    self.usernameTF.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    self.usernameTF.layer.borderWidth = 2;
    self.usernameTF.layer.cornerRadius = 6;
    NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc] initWithString:@"请输入账号"];
    [attributedStr2 setAttributes:attributes range:NSMakeRange(0, attributedStr2.length)];
    self.usernameTF.attributedPlaceholder = attributedStr2;
    self.usernameTF.defaultTextAttributes = attributes;
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    self.usernameTF.leftView = leftView;
    self.usernameTF.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTF.returnKeyType = UIReturnKeyDone;
    self.usernameTF.delegate = self;
    [self.contentView addSubview:self.usernameTF];
    [self.usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.passwordTF.mas_top).offset(-10);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250, 40));
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.usernameTF.mas_top).multipliedBy(.456f);
        make.size.mas_equalTo(CGSizeMake(90, 145));
    }];
    
    UIButton *touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touristBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [touristBtn setTitle:@"游客登录" forState:UIControlStateNormal];
    [touristBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [touristBtn addTarget:self action:@selector(touristBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:touristBtn];
    [touristBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[self.usernameTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        self.loginBtn.enabled = !isEmpty(self.usernameTF.text) && !isEmpty(self.passwordTF.text);
    }];
    [[self.passwordTF rac_textSignal] subscribeNext:^(id x) {
        self.loginBtn.enabled = !isEmpty(self.usernameTF.text) && !isEmpty(self.passwordTF.text);
    }];
}

#pragma mark - actions
- (void)loginBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.view nyx_startLoading];
    WEAK_SELF
    [LoginDataManager loginWithName:self.usernameTF.text password:self.passwordTF.text completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].loginStatus = YES;
    }];
}

- (void)securityBtnAction:(UIButton *)sender {
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
}

- (void)touristBtnAction:(UIButton *)sender {
    [self.view nyx_startLoading];
    WEAK_SELF
    [LoginDataManager loginWithName:@"17778023520" password:@"786027" completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].loginStatus = YES;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
