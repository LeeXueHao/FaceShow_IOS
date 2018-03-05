//
//  VerifyPhoneViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "MinePhoneInputView.h"
#import "MineVerifyCodeInputView.h"
#import "MineActionView.h"
#import "GetCheckCodeRequest.h"
#import "RegistYxbRequest.h"
#import "LoginUtils.h"
#import "MessagePromptView.h"
#import "AlertView.h"
#import "RegisterInfoViewController.h"
#import "CompleteUserInfoViewController.h"

@interface VerifyPhoneViewController ()
@property (nonatomic, strong) MinePhoneInputView *accountView;
@property (nonatomic, strong) MineVerifyCodeInputView *verifyCodeView;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) AlertView *alertView;

@property (nonatomic, strong) GetCheckCodeRequest *getVerifyCodeRequest;
@property (nonatomic, strong) RegistYxbRequest *registYxbRequest;
@end

@implementation VerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"验证手机号";
    [self setupUI];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self gotoNextStep];
    }];
    rightButton.enabled = NO;
    self.nextStepButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    BLOCK_EXEC(self.reScanCodeBlock);
    [super backAction];
}

- (void)setupUI {
    UIView *containerView = [[UIView alloc]init];
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    self.accountView = [[MinePhoneInputView alloc]init];
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
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

- (void)refreshNextStepButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.verifyCodeView text])) {
        self.nextStepButton.enabled = YES;
    }else {
        self.nextStepButton.enabled = NO;
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
    self.getVerifyCodeRequest = [[GetCheckCodeRequest alloc]init];
    self.getVerifyCodeRequest.mobile = self.accountView.text;
    self.getVerifyCodeRequest.clazsId = self.classID;
    [self.getVerifyCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.verifyCodeView stopTimer];
            if ([self isNetworkReachable]) {
                [self showAlertWithMessage:error.localizedDescription];
            }else {
                [self.view nyx_showToast:error.localizedDescription];
            }
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
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.registYxbRequest stopRequest];
    self.registYxbRequest = [[RegistYxbRequest alloc]init];
    self.registYxbRequest.mobile = self.accountView.text;
    self.registYxbRequest.code = self.verifyCodeView.text;
    self.registYxbRequest.clazsId = self.classID;
    [self.registYxbRequest startRequestWithRetClass:[RegistYxbRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        RegistYxbRequestItem *item = (RegistYxbRequestItem *)retItem;
        if (item.data.hasRegistUser.integerValue == 2) {
            NSString *message = [NSString stringWithFormat:@"成功加入【%@】！\n您之前已经是研修宝用户，用此手机号登录后即可查看到该班级。",item.data.clazsInfo.clazsName];
            [self showAlertWithMessage:message];
        }else if (item.data.hasRegistUser.integerValue == 0) {
            RegisterInfoViewController *vc = [[RegisterInfoViewController alloc]init];
            vc.classID = self.classID;
            vc.className = item.data.clazsInfo.clazsName;
            vc.mobile = self.accountView.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (item.data.hasRegistUser.integerValue == 1) {
            CompleteUserInfoViewController *vc = [[CompleteUserInfoViewController alloc]init];
            vc.userItem = item.data.sysUser;
            vc.isYanXiuUser = YES;
            vc.className = item.data.clazsInfo.clazsName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    MessagePromptView *promptView = [[MessagePromptView alloc]init];
    promptView.layer.cornerRadius = 7;
    promptView.clipsToBounds = YES;
    promptView.message = message;
    WEAK_SELF
    [promptView setConfirmBlock:^{
        STRONG_SELF
        [self.alertView hide];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.alertView = [[AlertView alloc]init];
    self.alertView.maskColor = [[UIColor colorWithHexString:@"333333"]colorWithAlphaComponent:.6];
    self.alertView.contentView = promptView;
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
        }];
    }];
}

@end
