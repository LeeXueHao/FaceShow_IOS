//
//  ResourceDownloadViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ResourceDownloadViewController.h"
#import "ScanPCCodeViewController.h"
#import "ResourceDownloadMethodOneView.h"
#import "ResourceDownloadMethodTwoView.h"
#import "GetResourceDetailRequest.h"
@interface ResourceDownloadViewController ()

@end

@implementation ResourceDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资源下载";
    [self setupUI];
}

- (void)setupUI {
    ResourceDownloadMethodOneView *methodOneView = [[ResourceDownloadMethodOneView alloc] initWithSourceUrl:self.downloadUrl];
    methodOneView.copyBlock = ^{
        [TalkingData trackEvent:@"链接地址下载"];
        [self.view nyx_showToast:@"资源链接已复制"];
    };
    [self.contentView addSubview:methodOneView];
    [methodOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
    }];

    ResourceDownloadMethodTwoView *methodTwoView = [[ResourceDownloadMethodTwoView alloc] init];
    WEAK_SELF
    methodTwoView.scanBlock = ^{
        STRONG_SELF
        [TalkingData trackEvent:@"扫码登录下载"];
        ScanPCCodeViewController *vc = [[ScanPCCodeViewController alloc]init];
        vc.crossJson = @{
                         @"bizType":@"resource",
                         @"bizId":@(self.resourceId.integerValue)
                         };
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.contentView addSubview:methodTwoView];
    [methodTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(methodOneView.mas_bottom).offset(5);
        make.bottom.mas_equalTo(0);
    }];
}

@end
