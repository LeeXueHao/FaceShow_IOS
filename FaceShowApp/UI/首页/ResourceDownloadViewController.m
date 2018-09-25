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
@interface ResourceDownloadViewController ()

@end

@implementation ResourceDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资源下载";
    [self setupUI];
}

- (void)setupUI {

    ResourceDownloadMethodOneView *methodOneView = [[ResourceDownloadMethodOneView alloc] initWithSourceUrl:self.sourceUrl];
    methodOneView.copyBlock = ^{
        [self.view nyx_showToast:@"资源链接已复制"];
    };
    [self.contentView addSubview:methodOneView];
    [methodOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];

    ResourceDownloadMethodTwoView *methodTwoView = [[ResourceDownloadMethodTwoView alloc] init];
    WEAK_SELF
    methodTwoView.scanBlock = ^{
        STRONG_SELF
        ScanPCCodeViewController *vc = [[ScanPCCodeViewController alloc]init];
        vc.bizType = @"2";//type2 资源
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.contentView addSubview:methodTwoView];
    [methodTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(methodOneView.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-40);
    }];
    


}

@end
