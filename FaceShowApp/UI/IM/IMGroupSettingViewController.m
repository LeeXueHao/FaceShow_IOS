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
#import "IMUserInterface.h"
#import "IMGroupMemberView.h"
#import "IMGroupMemberViewController.h"

@interface IMGroupSettingViewController ()
@property(nonatomic, strong) IMSwitchSettingView *hushView;
@property(nonatomic, strong) IMSwitchSettingView *unremindView;
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

    IMGroupMemberView *groupMemberView = [[IMGroupMemberView alloc] init];
    groupMemberView.title = @"群成员";
    WEAK_SELF
    groupMemberView.clickContentBlock = ^{
        STRONG_SELF
        IMGroupMemberViewController *groupController = [[IMGroupMemberViewController alloc] init];
        groupController.topicId = [NSString stringWithFormat:@"%lld",self.topic.topicID];
        [self.navigationController pushViewController:groupController animated:YES];
    };
    [self.view addSubview:groupMemberView];
    [groupMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classNameView.mas_bottom).offset(5);
        make.height.mas_equalTo(45);
    }];
    
    IMSwitchSettingView *hushView = [[IMSwitchSettingView alloc]init];
    hushView.title = @"学员禁言";
    hushView.desc = @"开启后，学员不可以发送消息，只有班主任可以发";
    hushView.isOn = [self.topic.personalConfig.speak isEqualToString:@"0"] ? YES : NO;
    self.hushView = hushView;
    [hushView setStateChangeBlock:^(BOOL isOn) {
        STRONG_SELF
    }];
    
    IMSwitchSettingView *unremindView = [[IMSwitchSettingView alloc]init];
    unremindView.title = @"消息免打扰";
    unremindView.desc = @"开启后，不会收到消息提醒";
    BOOL isOnState = [self.topic.personalConfig.quite isEqualToString:@"1"] ? YES : NO;
    unremindView.isOn = isOnState;
    self.unremindView = unremindView;
    [unremindView setStateChangeBlock:^(BOOL isOn) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [IMUserInterface updatePersonalConfigWithTopicId:self.topic.topicID quite:isOn ? @"1" : @"0"  completeBlock:^(NSError *error) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
                self.unremindView.isOn = isOnState;
                return;
            }
        }];
    }];
    
    if (self.isManager) {
        [self.view addSubview:hushView];
        [self.view addSubview:unremindView];
        [hushView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(groupMemberView.mas_bottom).mas_offset(5);
        }];
        [unremindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(hushView.mas_bottom).mas_offset(5);
        }];
    }else {
        [self.view addSubview:unremindView];
        [unremindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(groupMemberView.mas_bottom).mas_offset(5);
        }];
    }
}

@end
