//
//  RegisterInfoViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "RegisterInfoViewController.h"
#import "MinePasswordInputView.h"
#import "MineNameInputView.h"
#import "LoginUtils.h"
#import "RegistUnenterAndYxbRequest.h"
#import "CompleteUserInfoViewController.h"

@interface RegisterInfoViewController ()
@property (nonatomic, strong) MinePasswordInputView *passwordView;
@property (nonatomic, strong) MineNameInputView *nameView;
@property (nonatomic, strong) UIButton *nextStepButton;

@property (nonatomic, strong) RegistUnenterAndYxbRequest *registerRequest;
@end

@implementation RegisterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"填写注册信息";
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
        make.bottom.mas_equalTo(-40);
    }];
    self.passwordView = [[MinePasswordInputView alloc]init];
    WEAK_SELF
    [self.passwordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshNextStepButton];
    }];
    [containerView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(45);
    }];
    self.nameView = [[MineNameInputView alloc]init];
    [self.nameView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshNextStepButton];
    }];
    [containerView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.passwordView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)refreshNextStepButton {
    if (!isEmpty([self.passwordView text])&&!isEmpty([self.nameView text])) {
        self.nextStepButton.enabled = YES;
    }else {
        self.nextStepButton.enabled = NO;
    }
}

- (void)gotoNextStep {
    if (![LoginUtils isPasswordValid:self.passwordView.text]) {
        [self.view nyx_showToast:@"密码长度需要在6-20位之间"];
        return;
    }
    if ([LoginUtils hasEmpty:self.passwordView.text]) {
        [self.view nyx_showToast:@"密码不能包含空格"];
        return;
    }
    if (![LoginUtils isNameValid:self.nameView.text]) {
        [self.view nyx_showToast:@"姓名长度不能超过6位"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.registerRequest stopRequest];
    self.registerRequest = [[RegistUnenterAndYxbRequest alloc]init];
    self.registerRequest.mobile = self.mobile;
    self.registerRequest.clazsId = self.classID;
    self.registerRequest.name = self.nameView.text;
    self.registerRequest.password = [self.passwordView.text md5];
    [self.registerRequest startRequestWithRetClass:[RegistUnenterAndYxbRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        RegistUnenterAndYxbRequestItem *item = (RegistUnenterAndYxbRequestItem *)retItem;
        CompleteUserInfoViewController *vc = [[CompleteUserInfoViewController alloc]init];
        vc.userItem = item.data.sysUser;
        vc.className = self.className;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
