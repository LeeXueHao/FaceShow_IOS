//
//  IMPrivateSettingViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMPrivateSettingViewController.h"
#import "IMMemberInfoView.h"
#import "IMTitleContentView.h"
#import "IMSwitchSettingView.h"
#import "IMManager.h"
#import "IMTopicInfoItem.h"
#import "ContactMemberContactsRequest.h"
#import "IMUserInterface.h"

@interface IMPrivateSettingViewController ()
@property(nonatomic, strong) IMSwitchSettingView *unremindView;
@end

@implementation IMPrivateSettingViewController

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
    IMMemberInfoView *infoView = [[IMMemberInfoView alloc]init];
    if (self.topic) {
        for (IMMember *member in self.topic.members) {
            if (member.memberID != [IMManager sharedInstance].currentMember.memberID) {
                infoView.member = member;
                break;
            }
        }
    }else {
        infoView.member = self.info.member;
    }
    
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(75);
    }];
    IMTitleContentView *classNameView = [[IMTitleContentView alloc]init];
    classNameView.title = @"来自";
    classNameView.name = self.topic ? self.topic.group : self.info.group.groupName;
    [self.view addSubview:classNameView];
    [classNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(infoView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(45);
    }];
    
    IMSwitchSettingView *unremindView = [[IMSwitchSettingView alloc]init];
    unremindView.title = @"消息免打扰";
    unremindView.desc = @"开启后，不会收到消息提醒";
    BOOL isOnState = self.topic ? ([self.topic.personalConfig.quite isEqualToString:@"1"] ? YES : NO) : NO;
    unremindView.isOn = isOnState;
    self.unremindView = unremindView;
    WEAK_SELF
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
    [self.view addSubview:unremindView];
    [unremindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classNameView.mas_bottom).mas_offset(5);
    }];
}

@end
