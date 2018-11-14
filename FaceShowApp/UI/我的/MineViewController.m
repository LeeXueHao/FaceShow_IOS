//
//  MineViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "MineUserHeaderCell.h"
#import "MineDefaultCell.h"
#import "MineTableFooterView.h"
#import "FSDefaultHeaderFooterView.h"
#import "UserInfoViewController.h"
#import "SignInRecordViewController.h"
#import "UserModel.h"
#import "ClassSelectionViewController.h"
#import "HuBeiUserInfoViewController.h"
#import "ForgotPasswordViewController.h"
#import "MineCertiViewController.h"
#import "UserPromptsManager.h"
#import "AboutFaceShowViewController.h"
#import "YXInitRequest.h"

@interface MineViewController ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UIButton *mineCertiButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) GetUserInfoRequest *userInfoRequest;

@end

@implementation MineViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupObservers];
    if ([UserManager sharedInstance].userModel == nil) {
        [self requestForUserInfo];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景"]];
    backImageView.clipsToBounds = YES;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 6;
    self.avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    [self.view addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(24);
        } else {
            make.top.mas_equalTo(44);
        }
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(10.75f);
    }];
    
    self.projectLabel = [[UILabel alloc] init];
    self.projectLabel.font = [UIFont systemFontOfSize:13];
    self.projectLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.projectLabel.textAlignment = NSTextAlignmentCenter;
    self.projectLabel.text = [UserManager sharedInstance].userModel.projectClassInfo.data.projectInfo.projectName;
    [self.view addSubview:self.projectLabel];
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    
    self.classNameLabel = [[UILabel alloc] init];
    self.classNameLabel.font = [UIFont systemFontOfSize:13];
    self.classNameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.classNameLabel.textAlignment = NSTextAlignmentCenter;
    self.classNameLabel.text = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsName;
    [self.view addSubview:self.classNameLabel];
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.projectLabel.mas_bottom).offset(3);
    }];
    
    UIButton *changeClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeClassBtn.clipsToBounds = YES;
    changeClassBtn.layer.cornerRadius = 6;
    changeClassBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    changeClassBtn.layer.borderWidth = 1;
    changeClassBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [changeClassBtn setTitle:@"切换班级" forState:UIControlStateNormal];
    [changeClassBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [changeClassBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateHighlighted];
    [changeClassBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [changeClassBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateHighlighted];
    [changeClassBtn addTarget:self action:@selector(changeClassBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeClassBtn];
    [changeClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.classNameLabel.mas_bottom).offset(10.5f);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(changeClassBtn.mas_bottom).mas_offset(20);
    }];

    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];

    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.textColor = [UIColor colorWithHexString:@"a4acb8"];
    versionLabel.text = [NSString stringWithFormat:@"版本号：V%@",[ConfigManager sharedInstance].clientVersion];
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(logoutBtn.mas_top).offset(-20);
        make.centerX.mas_equalTo(0);
    }];


    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(305*kPhoneWidthRatio, 10000);
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImageView.mas_bottom);
        make.bottom.mas_equalTo(versionLabel.mas_top);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton *classHomeBtn = [self optionBtnWithTitle:@"班级首页" normalImage:@"首页icon正常态" highlightedImage:@"首页icon点击态"];
    [scroll addSubview:classHomeBtn];
    [classHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton *mineInfoBtn = [self optionBtnWithTitle:@"我的资料" normalImage:@"我的icon正常态" highlightedImage:@"我的icon点击态"];
    [scroll addSubview:mineInfoBtn];
    [mineInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(classHomeBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    self.mineCertiButton = [self optionBtnWithTitle:@"我的证书" normalImage:@"我的证书正常态" highlightedImage:@"我的证书点击态"];
    [scroll addSubview:self.mineCertiButton];
    [self.mineCertiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mineInfoBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    UIButton *signInfoBtn = [self optionBtnWithTitle:@"签到记录" normalImage:@"签到记录正常态" highlightedImage:@"签到记录点击态"];
    [scroll addSubview:signInfoBtn];
    [signInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mineCertiButton.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    UIButton *passwordBtn = [self optionBtnWithTitle:@"修改密码" normalImage:@"忘记密码icon正常态" highlightedImage:@"忘记密码icon选择态"];
    [scroll addSubview:passwordBtn];
    [passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signInfoBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];

    self.aboutButton = [self optionBtnWithTitle:@"关于我们" normalImage:@"关于" highlightedImage:@"关于点击"];
    [scroll addSubview:self.aboutButton];
    [self.aboutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];


}


- (UIButton *)optionBtnWithTitle:(NSString *)title normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [btn addTarget:self action:@selector(optionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - setupObservers
-(void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kYXUploadUserPicSuccessNotification" object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self reload];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewCertificateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        UIView *redPointView = [[UIView alloc] init];
        redPointView.layer.cornerRadius = 4.5f;
        redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
        [self.mineCertiButton.titleLabel addSubview:redPointView];
        [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mineCertiButton.titleLabel.mas_right);
            make.top.mas_equalTo(-3.5);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasReadCertificateNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self.mineCertiButton.titleLabel removeSubviews];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXInitSuccessNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if ([YXInitHelper sharedHelper].hasNewVersion) {
            UIView *redPointView = [[UIView alloc] init];
            redPointView.layer.cornerRadius = 4.5f;
            redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
            [self.aboutButton.titleLabel addSubview:redPointView];
            [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.aboutButton.titleLabel.mas_right);
                make.top.mas_equalTo(-3.5);
                make.size.mas_equalTo(CGSizeMake(9, 9));
            }];
        }
    }];
}
- (void)reload{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
}


#pragma mark - actions
- (void)changeClassBtnAction {
    [TalkingData trackEvent:@"点击切换班级"];
    ClassSelectionViewController *selectionVC = [[ClassSelectionViewController alloc] init];
    [self.navigationController pushViewController:selectionVC animated:YES];
}

- (void)logoutBtnAction {
    [TalkingData trackEvent:@"退出登录"];
    [UserManager sharedInstance].loginStatus = NO;
}

- (void)optionBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"班级首页"]) {
        [TalkingData trackEvent:@"点击班级首页"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"签到记录"]) {
        [TalkingData trackEvent:@"点击签到记录"];
        SignInRecordViewController *signInRecordVC = [[SignInRecordViewController alloc] init];
        [self.navigationController pushViewController:signInRecordVC animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"我的资料"]) {
#ifdef HuBeiApp
        HuBeiUserInfoViewController *VC = [[HuBeiUserInfoViewController alloc] init];
        WEAK_SELF
        [VC setCompleteBlock:^{
            STRONG_SELF
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
            }];
            self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
        }];
        [self.navigationController pushViewController:VC animated:YES];
#else
        UserInfoViewController *VC = [[UserInfoViewController alloc] init];
        WEAK_SELF
        [VC setCompleteBlock:^{
            STRONG_SELF
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
            }];
            self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
        }];
        [self.navigationController pushViewController:VC animated:YES];
#endif
    }else if ([sender.titleLabel.text isEqualToString:@"修改密码"]) {
        [TalkingData trackEvent:@"修改密码"];
        ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] init];
        vc.isModify = YES;
        vc.phoneNum = [UserManager sharedInstance].userModel.mobilePhone;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"我的证书"]) {
        MineCertiViewController *mine = [[MineCertiViewController alloc]init];
        [self.navigationController pushViewController:mine animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"关于我们"]){
        AboutFaceShowViewController *about = [[AboutFaceShowViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

#pragma mark - request
- (void)requestForUserInfo{
    GetUserInfoRequest *request = [[GetUserInfoRequest alloc] init];
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        GetUserInfoRequestItem *item = retItem;
        if (item.data != nil) {
            [[UserManager sharedInstance].userModel updateFromUserInfo:item.data];
            self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
            }];
        }
    }];
    self.userInfoRequest = request;
}
@end
