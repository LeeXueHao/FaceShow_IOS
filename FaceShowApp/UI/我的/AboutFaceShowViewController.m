//
//  AboutFaceShowViewController.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AboutFaceShowViewController.h"
#import "FeedbackViewController.h"
#import "AboutItemView.h"


@interface AboutFaceShowViewController ()
@property (nonatomic, strong) MASViewAttribute *lastArribute;
@end

@implementation AboutFaceShowViewController

- (void)dealloc{
    NSLog(@"%@ -- dealloc",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于App";


#ifdef HuBeiApp
    NSString *imageName = @"湖北师训";
    NSString *updateURL = @"https://itunes.apple.com/cn/app/id1400673669?mt=8";
#else
    NSString *imageName = @"研修宝";
    NSString *updateURL = @"https://itunes.apple.com/cn/app/id1287430670?mt=8";
#endif

    UIImageView *appIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:appIconImageView];
    [appIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];

    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"当前版本：V%@",[ConfigManager sharedInstance].clientVersion];
    versionLabel.font = [UIFont systemFontOfSize:17];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor colorWithHexString:@"B1B4B7"];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appIconImageView.mas_bottom).offset(18);
        make.left.right.mas_equalTo(0);
    }];


    AboutItemView *suggestItem = [[AboutItemView alloc] initWithItemName:@"意见反馈"];
    suggestItem.showLine = YES;
    WEAK_SELF
    suggestItem.clickBlock = ^{
        STRONG_SELF
        [TalkingData trackEvent:@"点击意见反馈"];
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    };
    [self.view addSubview:suggestItem];
    [suggestItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(versionLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(45);
    }];

    AboutItemView *updateItem = [[AboutItemView alloc] initWithItemName:@"检查新版本"];
    updateItem.showLine = NO;
    updateItem.clickBlock = ^{
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
    };
    [self.view addSubview:updateItem];
    [updateItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(suggestItem.mas_bottom);
        make.height.mas_equalTo(45);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
