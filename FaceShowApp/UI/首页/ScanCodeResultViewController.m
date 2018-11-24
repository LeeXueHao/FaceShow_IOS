//
//  ScanCodeResultViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScanCodeResultViewController.h"
#import "SignInDetailViewController.h"
#import "GetInteractAfterStepRequest.h"
#import "ScheduleDetailViewController.h"

typedef NS_ENUM(NSUInteger, SignInError) {
    SignInErrorInvaildQRcode = 210411, // 签到不存在或已停用（二维码非法）
    SignInErrorUnstart, // 签到未开始
    SignInErrorHasFinished, // 签到已结束
    SignInErrorHasSignedIn, // 用户已签到（已经签过到，重复扫码）
    SignInErrorInvaildClass = 210305 // 您不是班级成员
};

@interface ScanCodeResultViewController ()

@property (nonatomic, strong) UIImageView *signInImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *blackLabel;
@property (nonatomic, strong) UILabel *grayLabel;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) GetInteractAfterStepRequest *afterRequest;
@property (nonatomic, strong) GetInteractAfterStepRequestItem *item;
@end

@implementation ScanCodeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.title = @"签到";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.signInImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.signInImageView];
    [self.signInImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(95 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signInImageView.mas_bottom).offset(9);
        make.centerX.mas_equalTo(0);
    }];
    
    self.blackLabel = [[UILabel alloc] init];
    self.blackLabel.font = [UIFont systemFontOfSize:14];
    self.blackLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.blackLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.blackLabel];
    
    self.grayLabel = [[UILabel alloc] init];
    self.grayLabel.font = [UIFont systemFontOfSize:13];
    self.grayLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.grayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.grayLabel];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.clipsToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 7;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    self.confirmBtn.layer.borderWidth = 2;
    [self.confirmBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.confirmBtn];
}

- (void)setModel {
    BOOL hasSignedIn = !isEmpty(self.error) && self.error.code.integerValue == SignInErrorHasSignedIn;
    if (!isEmpty(self.data) || hasSignedIn) {
        self.signInImageView.image = [UIImage imageNamed:hasSignedIn ? @"签到失败图标" : @"签到成功图标"];
        self.titleLabel.text = hasSignedIn ? self.error.message : self.data.successPrompt;
        self.grayLabel.text = @"签到时间";
        [self.grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(40);
            make.centerX.mas_equalTo(0);
        }];
        self.blackLabel.text = [hasSignedIn ? self.error.data.userSignIn.signinTime : self.data.signinTime omitSecondOfFullDateString];
        [self.blackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.grayLabel.mas_bottom).offset(8);
            make.centerX.mas_equalTo(0);
        }];
        [self.confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.blackLabel.mas_bottom).offset(50);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(112, 40));
            make.bottom.mas_equalTo(-215 * kPhoneHeightRatio);
        }];
        [self requestAfterInfo];
    } else if (!isEmpty(self.error)) {
        self.signInImageView.image = [UIImage imageNamed:@"签到失败图标"];
        self.titleLabel.text = @"签到失败";
        self.blackLabel.text = self.error.message;
        NSString *defaultStr = self.positionSignIn? @"":@"请扫描最新签到二维码";
        self.grayLabel.text = (self.error.code.integerValue == SignInErrorUnstart || self.error.code.integerValue == SignInErrorHasFinished) ? [NSString stringWithFormat:@"%@ - %@", [self.error.data.startTime omitSecondOfFullDateString], [self.error.data.endTime omitSecondOfFullDateString]] : defaultStr;
        [self.blackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(40);
            make.centerX.mas_equalTo(0);
        }];
        [self.grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.blackLabel.mas_bottom).offset(8);
            make.centerX.mas_equalTo(0);
        }];
        [self.confirmBtn setTitle:@"重新签到" forState:UIControlStateNormal];
        if (self.positionSignIn) {
            [self.confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
        }
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.grayLabel.mas_bottom).offset(50);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(112, 40));
            make.bottom.mas_equalTo(-215 * kPhoneHeightRatio);
        }];
    }
}

- (void)clickConfirmBtn{
    if (self.item && self.item.data.afterSteps.count != 0) {
        [self goScheduleDetail];
        return;
    }else{
        [self backAction];
    }
}

- (void)backAction {
    if ([self.confirmBtn.titleLabel.text isEqualToString:@"确 定"]) {
        if (self.currentIndexPath) {
            if ([self.navigationController.viewControllers[1] isKindOfClass:[SignInDetailViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }
            if (self.error.code.integerValue != SignInErrorHasSignedIn) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadSignInRecordNotification" object:@{
                                                                                                                       @"kSignInRecordCurrentIndexPath" : self.currentIndexPath, @"kCurrentIndexPathSucceedSigninTime" : self.data.signinTime}];
            }
        } else {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if (self.positionSignIn) {
                    [super backAction];
                }else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    } else {
        [super backAction];
        BLOCK_EXEC(self.reScanCodeBlock);
    }
}

- (void)requestAfterInfo{
    [self.afterRequest stopRequest];
    self.afterRequest = [[GetInteractAfterStepRequest alloc] init];
    self.afterRequest.stepId = self.stepId;
    WEAK_SELF
    [self.afterRequest startRequestWithRetClass:[GetInteractAfterStepRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        self.item = retItem;
    }];
}

- (void)goScheduleDetail{
    ScheduleDetailViewController *vc = [[ScheduleDetailViewController alloc]init];
    GetInteractAfterStepRequestItem_afterSteps *afterStep = self.item.data.afterSteps.firstObject;
    vc.urlStr = afterStep.url;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
