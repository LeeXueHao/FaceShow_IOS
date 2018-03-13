//
//  ChatPlaceViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/3/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ChatPlaceViewController.h"
#import "YXDrawerController.h"

@interface ChatPlaceViewController ()

@end

@implementation ChatPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊聊";
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
-(void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"底色"]];
    [self.view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    
    UIImageView *centerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"插画"]];
    [self.view addSubview:centerImage];
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(55);
    }];
    
    UILabel *forwardIngLabel = [[UILabel alloc]init];
    forwardIngLabel.text = @"敬请期待...";
    forwardIngLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    forwardIngLabel.font = [UIFont systemFontOfSize:29];
    [self.view addSubview:forwardIngLabel];
    [forwardIngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(centerImage.mas_bottom).offset(36);
    }];
    
    UILabel *wantChatLabel = [[UILabel alloc]init];
    wantChatLabel.text = @"想和班级里的其他同学一起交流讨论？";
    wantChatLabel.textColor = [UIColor colorWithHexString:@"999999"];
    wantChatLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:wantChatLabel];
    [wantChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(forwardIngLabel.mas_bottom).offset(18);
    }];
    
    
    UILabel *continueLearnLabel = [[UILabel alloc]init];
    continueLearnLabel.text = @"面授结束了还想继续研究互相学习？";
    continueLearnLabel.textColor = [UIColor colorWithHexString:@"999999"];
    continueLearnLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:continueLearnLabel];
    [continueLearnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(wantChatLabel.mas_bottom).offset(9);
    }];
    
    UILabel *chatModuleLabel = [[UILabel alloc]init];
    chatModuleLabel.text = @"聊聊模块即将上线!";
    chatModuleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    chatModuleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:chatModuleLabel];
    [chatModuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(continueLearnLabel.mas_bottom).offset(9);
    }];

    
    
    
}


@end
