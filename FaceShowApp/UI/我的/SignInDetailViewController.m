//
//  SignInDetailViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDetailViewController.h"
#import "ScanCodeViewController.h"
#import "GetSignInRecordListRequest.h"
#import "UserSignInRequest.h"
#import "ScanCodeResultViewController.h"

@interface SignInDetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeScheduleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UILabel *signedInTimeLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *signInBtn;
@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *placeNameLabel;
@property (nonatomic, strong) UILabel *statusTitleLabel;
@property (nonatomic, strong) UserSignInRequest *signInRequest;
@end

@implementation SignInDetailViewController

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
    self.title = @"签到详情";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(114 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *timeScheduleTitleLabel = [[UILabel alloc] init];
    timeScheduleTitleLabel.font = [UIFont systemFontOfSize:13];
    timeScheduleTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    timeScheduleTitleLabel.text = @"签到时间安排";
    [self.contentView addSubview:timeScheduleTitleLabel];
    [timeScheduleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    
    self.timeScheduleLabel = [[UILabel alloc] init];
    self.timeScheduleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.timeScheduleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.timeScheduleLabel];
    [self.timeScheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeScheduleTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *typeLabel = [timeScheduleTitleLabel clone];
    typeLabel.text = @"签到类型";
    [self.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeScheduleLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    self.typeNameLabel = [self.timeScheduleLabel clone];
    [self.contentView addSubview:self.typeNameLabel];
    [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(typeLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *placeLabel = [typeLabel clone];
    placeLabel.text = @"签到地点";
    self.placeLabel = placeLabel;
    [self.contentView addSubview:placeLabel];
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeNameLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    self.placeNameLabel = [self.typeNameLabel clone];
    self.placeNameLabel.numberOfLines = 0;
    self.placeNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.placeNameLabel];
    [self.placeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(placeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *statusTitleLabel = [[UILabel alloc] init];
    statusTitleLabel.font = [UIFont systemFontOfSize:13];
    statusTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    statusTitleLabel.text = @"本次签到";
    [self.contentView addSubview:statusTitleLabel];
    self.statusTitleLabel = statusTitleLabel;
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:18];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    self.timeTitleLabel = [[UILabel alloc] init];
    self.timeTitleLabel.font = [UIFont systemFontOfSize:13];
    self.timeTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeTitleLabel.text = @"签到时间";
    self.timeTitleLabel.hidden = YES;
    [self.contentView addSubview:self.timeTitleLabel];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(29);
        make.centerX.mas_equalTo(0);
    }];
    
    self.signedInTimeLabel = [[UILabel alloc] init];
    self.signedInTimeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.signedInTimeLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    self.signedInTimeLabel.hidden = YES;
    [self.contentView addSubview:self.signedInTimeLabel];
    [self.signedInTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeTitleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-273 * kPhoneHeightRatio);
    }];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.font = [UIFont systemFontOfSize:13];
    self.tipsLabel.textColor = [UIColor colorWithHexString:@"999999"];
    NSString *tips = [self.signIn.signinType isEqualToString:@"1"]? @"请点击下面按钮，扫描二维码进行现场签到":@"请点击下面按钮，进行位置签到";
    self.tipsLabel.text = tips;
    self.tipsLabel.hidden = YES;
    [self.contentView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(60);
        make.centerX.mas_equalTo(0);
    }];
    
    self.signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signInBtn.clipsToBounds = YES;
    self.signInBtn.layer.cornerRadius = 7;
    self.signInBtn.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    self.signInBtn.layer.borderWidth = 2;
    [self.signInBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.signInBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    [self.signInBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.signInBtn setTitle:@"签 到" forState:UIControlStateNormal];
    [self.signInBtn addTarget:self action:@selector(signInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.signInBtn.hidden = YES;
    [self.contentView addSubview:self.signInBtn];
    [self.signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
        make.bottom.mas_equalTo(-178 * kPhoneHeightRatio);
    }];
}

- (void)signInBtnAction:(UIButton *)sender {
    [TalkingData trackEvent:@"点击签到详情中的签到按钮"];
    if ([self.signIn.signinType isEqualToString:@"1"]) {
        ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
        scanCodeVC.navigationItem.title = @"签到";
        scanCodeVC.currentIndexPath = self.currentIndexPath;
        [self.navigationController pushViewController:scanCodeVC animated:YES];
    }else {
        [self signInWithData:self.signIn];
    }    
}

- (void)signInWithData:(GetSignInRecordListRequestItem_SignIn *)data {
    [self.view nyx_startLoading];
    [self.signInRequest stopRequest];
    self.signInRequest = [[UserSignInRequest alloc] init];
    self.signInRequest.stepId = data.stepId;
    self.signInRequest.positionSignIn = YES;
    self.signInRequest.positionRange = data.positionRange;
    self.signInRequest.signInExts = data.signInExts;
//    self.signInRequest.signinPosition = data.signinPosition;
    WEAK_SELF
    [self.signInRequest startRequestWithRetClass:[UserSignInRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error && (error.code == 1||error.code == -1)) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        UserSignInRequestItem *item = (UserSignInRequestItem *)retItem;
        ScanCodeResultViewController *scanCodeResultVC = [[ScanCodeResultViewController alloc] init];
        scanCodeResultVC.stepId = self.signIn.stepId;
        scanCodeResultVC.data = error ? nil : item.data;
        scanCodeResultVC.error = error ? item.error : nil;
        scanCodeResultVC.positionSignIn = YES;
        scanCodeResultVC.currentIndexPath = self.currentIndexPath;
        [self.navigationController pushViewController:scanCodeResultVC animated:YES];
    }];
}

- (void)setModel {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.signIn.title];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 27;
    style.alignment = NSTextAlignmentCenter;
    [attributedStr setAttributes:@{
                                   NSParagraphStyleAttributeName : style,
                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]
                                   } range:NSMakeRange(0, attributedStr.length)];
    self.titleLabel.attributedText = attributedStr;
    NSString *endTime = [self.signIn.endTime omitSecondOfFullDateString];
    endTime = [endTime componentsSeparatedByString:@" "].lastObject;
    self.timeScheduleLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.signIn.startTime omitSecondOfFullDateString],endTime];
    self.statusLabel.text = isEmpty(self.signIn.userSignIn) ? @"您还未签到" : @"您已成功签到";
    if (isEmpty(self.signIn.userSignIn)) {
        self.tipsLabel.hidden = NO;
        self.signInBtn.hidden = NO;
        if (self.signIn.openStatus.integerValue != 6) {
            self.tipsLabel.hidden = YES;
            self.signInBtn.hidden = YES;
        }
    } else {
        self.timeTitleLabel.hidden = NO;
        self.signedInTimeLabel.hidden = NO;
        self.signedInTimeLabel.text = [self.signIn.userSignIn.signinTime omitSecondOfFullDateString];
    }
    BOOL placeSignin = [self.signIn.signinType isEqualToString:@"2"];
    if (placeSignin) {
        self.typeNameLabel.text = @"位置签到";
        if (isEmpty(self.signIn.userSignIn)) {
            __block NSMutableString *signPlace = [NSMutableString string];
            [self.signIn.signInExts enumerateObjectsUsingBlock:^(GetSignInRequest_Item_signInExts *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [signPlace appendString:[NSString stringWithFormat:@"%lu.%@\n",(unsigned long)idx + 1,obj.positionSite]];
            }];
            self.placeNameLabel.text = signPlace;
        }else{
            self.placeNameLabel.text = self.signIn.userSignIn.signinSite;
        }

        [self.statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.placeNameLabel.mas_bottom).offset(29);
            make.centerX.mas_equalTo(0);
        }];
    }else {
        self.typeNameLabel.text = @"扫码签到";
        [self.statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.typeNameLabel.mas_bottom).offset(29);
            make.centerX.mas_equalTo(0);
        }];
        self.placeLabel.hidden = YES;
        self.placeNameLabel.hidden = YES;
    }
}

@end
