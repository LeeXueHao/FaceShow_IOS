//
//  LoginViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginDataManager.h"
#import "ForgotPasswordViewController.h"
#import "ClassEmptyViewController.h"
#import "ScanCodeViewController.h"
#import "YXInputView.h"
#import "GetVerifyCodeRequest.h"
#import "LoginUtils.h"

@interface LoginViewController ()
@property (nonatomic, strong) YXInputView *inputView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) GetVerifyCodeRequest *getVerifyCodeRequest;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomHeightWhenKeyboardShows = 20;
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - setupUI
- (void)setupUI {
    self.scrollView.bounces = NO;
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
    [self.loginBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage yx_createImageWithColor:[[UIColor colorWithHexString:@"1da1f2"] colorWithAlphaComponent:.25f]] forState:UIControlStateDisabled];
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideBottom).offset(-120);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(-120);
        }
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(300 * kPhoneWidthRatio, 46));
    }];
    self.loginBtn.enabled = NO;

    self.inputView = [[YXInputView alloc] init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.loginBtn.mas_top).offset(-30);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    WEAK_SELF
    self.inputView.sendVerifyCodeBlock = ^(NSString * _Nonnull telPhoneNumber) {
        STRONG_SELF
        [self sendVerifyCodeWithPhoneNumber:telPhoneNumber];
    };
    self.inputView.btnEnabledBlock = ^(BOOL enabled) {
        STRONG_SELF
        self.loginBtn.enabled = enabled;
    };

    UIButton *quickbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickbtn setTitle:@"快捷登录" forState:0];
    quickbtn.selected = YES;
    [quickbtn setTitleColor:[UIColor colorWithHexString:@"181928"] forState:UIControlStateSelected];
    [quickbtn setTitleColor:[UIColor colorWithHexString:@"929699"] forState:UIControlStateNormal];
    quickbtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.view addSubview:quickbtn];
    [quickbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-20);
        make.left.mas_equalTo(self.inputView.mas_left).offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor colorWithHexString:@"4C9EEB"];
    [self.view addSubview:blueView];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(quickbtn);
        make.size.mas_equalTo(CGSizeMake(30, 2));
        make.top.mas_equalTo(quickbtn.mas_bottom).offset(5);
    }];

    UIButton *login = [quickbtn clone];
    [login setTitle:@"密码登录" forState:0];
    [self.view addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-20);
        make.right.mas_equalTo(self.inputView.mas_right).offset(-50);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];

    [[quickbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        quickbtn.selected = YES;
        login.selected = NO;
        self.inputView.type = YXInputViewType_QuickLogin;
        [blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(quickbtn);
            make.size.mas_equalTo(CGSizeMake(30, 2));
            make.top.mas_equalTo(quickbtn.mas_bottom).offset(5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            if (self.scrollView.contentInset.bottom > 0) {
                [self.inputView setFocus];
            }
        }];
    }];


    [[login rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        login.selected = YES;
        quickbtn.selected = NO;
        self.inputView.type = YXInputViewType_Default;
        [blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(login);
            make.size.mas_equalTo(CGSizeMake(30, 2));
            make.top.mas_equalTo(login.mas_bottom).offset(5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            if (self.scrollView.contentInset.bottom > 0) {
                [self.inputView setFocus];
            }
        }];
    }];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideTop).offset(19);
        } else {
            // Fallback on earlier versions
            make.top.mas_equalTo(19);
        }
        make.size.mas_equalTo(CGSizeMake(175, 75));
    }];
    
    UIButton *touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touristBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [touristBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [touristBtn setTitleColor:[UIColor colorWithHexString:@"9D9CA1"] forState:UIControlStateNormal];
    [touristBtn addTarget:self action:@selector(forgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:touristBtn];
    [touristBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginBtn.mas_right);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideBottom).offset(-84);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(-84);
        }
    }];
    
    UIButton *registerBtn = [touristBtn clone];
    [registerBtn setTitle:@"扫码注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_left);
        make.bottom.mas_equalTo(touristBtn);
    }];
}

#pragma mark - actions
- (void)loginBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.view nyx_startLoading];
    NSString *telNumber = [self.inputView.telPhoneNumber yx_stringByTrimmingCharacters];
    WEAK_SELF
    AppLoginType type = self.inputView.type == YXInputViewType_Default?AppLoginType_AccountLogin:AppLoginType_AppCodeLogin;
    [LoginDataManager loginWithName:telNumber password:self.inputView.password loginType:type completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [UserManager sharedInstance].userModel = nil;
            if (type ==YXInputViewType_Default) {
                [self.inputView clearPassWord];
                self.loginBtn.enabled = NO;
            }
            if (error.code != 10086) {
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            ClassEmptyViewController *vc = [[ClassEmptyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        [UserManager sharedInstance].loginStatus = YES;
    }];
}

- (void)forgetBtnAction:(UIButton *)sender {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerBtnAction:(UIButton *)sender {
    ScanCodeViewController *vc = [[ScanCodeViewController alloc]init];
    vc.navigationItem.title = @"扫码注册";
    vc.prompt = @"请扫描二维码完成注册";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber{
    if (![LoginUtils isPhoneNumberValid:phoneNumber]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.inputView startTimer];
    [self.getVerifyCodeRequest stopRequest];
    self.getVerifyCodeRequest = [[GetVerifyCodeRequest alloc]init];
    self.getVerifyCodeRequest.mobile = phoneNumber;
    [self.getVerifyCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.inputView stopTimer];
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"验证码已发送，请注意查收"];
    }];
}

@end
