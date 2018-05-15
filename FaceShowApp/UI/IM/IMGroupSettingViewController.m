//
//  IMGroupSettingViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMGroupSettingViewController.h"
#import "IMTitleContentView.h"
#import "IMSwitchSettingView.h"

@interface IMGroupSettingViewController ()

@end

@implementation IMGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"聊聊设置";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    IMTitleContentView *classNameView = [[IMTitleContentView alloc]init];
    classNameView.title = @"班级名称";
    classNameView.name = self.topic.group;
    [self.view addSubview:classNameView];
    [classNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(45);
    }];
    
    IMSwitchSettingView *hushView = [[IMSwitchSettingView alloc]init];
    hushView.title = @"学员禁言";
    hushView.desc = @"开启后，学员不可以发送消息，只有班主任可以发";
    WEAK_SELF
    [hushView setStateChangeBlock:^(BOOL isOn) {
        STRONG_SELF
    }];
    
    IMSwitchSettingView *unremindView = [[IMSwitchSettingView alloc]init];
    unremindView.title = @"消息免打扰";
    unremindView.desc = @"开启后，不会受到消息提醒";
    [unremindView setStateChangeBlock:^(BOOL isOn) {
        STRONG_SELF
    }];
    
    if (self.isManager) {
        [self.view addSubview:hushView];
        [self.view addSubview:unremindView];
        [hushView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(classNameView.mas_bottom).mas_offset(5);
        }];
        [unremindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(hushView.mas_bottom).mas_offset(5);
        }];
    }else {
        [self.view addSubview:unremindView];
        [unremindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(classNameView.mas_bottom).mas_offset(5);
        }];
    }
}

@end
