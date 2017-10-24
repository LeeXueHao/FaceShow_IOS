//
//  ForgotPasswordViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "MinePhoneInputView.h"
#import "MineVerifyCodeInputView.h"
#import "MineActionView.h"
#import "MinePasswordInputView.h"
#import "GetVerifyCodeRequest.h"
#import "ResetPasswordRequest.h"
#import "LoginUtils.h"

@interface ForgotPasswordViewController ()
@property (nonatomic, strong) MinePhoneInputView *accountView;
@property (nonatomic, strong) MineVerifyCodeInputView *verifyCodeView;
@property (nonatomic, strong) MineActionView *nextStepView;
@property (nonatomic, strong) MinePasswordInputView *passwordView;
@property (nonatomic, strong) GetVerifyCodeRequest *getVerifyCodeRequest;
@property (nonatomic, strong) ResetPasswordRequest *resetPasswordRequest;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"忘记密码";
    [self setupUI];
//    WEAK_SELF
//    [self nyx_setupLeftWithImageName:@"关闭当前页面icon正常态" highlightImageName:@"关闭当前页面icon点击态" action:^{
//        STRONG_SELF
//        [self backAction];
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
//    UIImageView *topImageView = [[UIImageView alloc]init];
//    topImageView.image = [UIImage imageNamed:@"忘记密码头图"];
//    topImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:topImageView];
//    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.mas_equalTo(0);
//        make.height.mas_equalTo(200*kPhoneWidthRatio);
//    }];
    UIView *containerView = [[UIView alloc]init];
//    containerView.layer.cornerRadius = 5;
//    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    self.accountView = [[MinePhoneInputView alloc]init];
    self.accountView.inputView.textField.text = self.phoneNum;
    self.accountView.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountView.inputView.placeHolder = @"手机号";
    WEAK_SELF
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        if (self.accountView.text.length>11) {
            self.accountView.inputView.textField.text = [self.accountView.text substringToIndex:11];
        }
        [self refreshVerifyCodeView];
        [self refreshNextStepButton];
    }];
    [containerView addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(45);
    }];
    self.verifyCodeView = [[MineVerifyCodeInputView alloc]init];
    self.verifyCodeView.isActive = NO;
    [self.verifyCodeView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshNextStepButton];
    }];
    [self.verifyCodeView setSendAction:^{
        STRONG_SELF
        [self gotoGetVerifyCode];
    }];
    [containerView addSubview:self.verifyCodeView];
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    self.passwordView = [[MinePasswordInputView alloc]init];
    [self.passwordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshNextStepButton];
    }];
    [containerView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeView.mas_bottom).mas_offset(5);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    MineActionView *nextStepView = [[MineActionView alloc]init];
    nextStepView.title = @"提 交";
    [nextStepView setActionBlock:^{
        STRONG_SELF
        [self gotoNextStep];
    }];
    [self.contentView addSubview:nextStepView];
    [nextStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(35);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(250*kPhoneWidthRatio);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    self.nextStepView = nextStepView;
    
    [self refreshVerifyCodeView];
    [self refreshNextStepButton];
}

- (void)refreshNextStepButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.verifyCodeView text])&&!isEmpty([self.passwordView text])) {
        self.nextStepView.isActive = YES;
    }else {
        self.nextStepView.isActive = NO;
    }
}

- (void)refreshVerifyCodeView {
    self.verifyCodeView.isActive = !isEmpty([self.accountView text]);
}

- (void)gotoGetVerifyCode {
    if (![LoginUtils isPhoneNumberValid:self.accountView.text]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.verifyCodeView startTimer];
    [self.getVerifyCodeRequest stopRequest];
    self.getVerifyCodeRequest = [[GetVerifyCodeRequest alloc]init];
    self.getVerifyCodeRequest.mobile = self.accountView.text;
    [self.getVerifyCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.verifyCodeView stopTimer];
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"验证码已发送，请注意查收"];
    }];
}

- (void)gotoNextStep {
    if (![LoginUtils isPhoneNumberValid:self.accountView.text]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    if (![LoginUtils isPasswordValid:self.passwordView.text]) {
        [self.view nyx_showToast:@"密码长度需要在6-20位之间"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.resetPasswordRequest stopRequest];
    self.resetPasswordRequest = [[ResetPasswordRequest alloc]init];
    self.resetPasswordRequest.mobile = self.accountView.text;
    self.resetPasswordRequest.code = self.verifyCodeView.text;
    self.resetPasswordRequest.password = [self.passwordView.text md5];
    [self.resetPasswordRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view.window nyx_showToast:@"修改成功"];
        [self backAction];
    }];
}

@end
