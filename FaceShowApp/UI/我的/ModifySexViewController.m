//
//  ModifySexViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ModifySexViewController.h"
#import "SexItemView.h"
#import "UpdateUserInfoRequest.h"

@interface ModifySexViewController ()
@property (nonatomic, strong) SexItemView *maleView;
@property (nonatomic, strong) SexItemView *femaleView;
@property (nonatomic, strong) UpdateUserInfoRequest *request;
@end

@implementation ModifySexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改性别";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"保存" action:^{
        STRONG_SELF
        [self saveSex];
    }];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.maleView = [[SexItemView alloc]init];
    self.maleView.name = @"男";
    WEAK_SELF
    [self.maleView setSelectionBlock:^{
        STRONG_SELF
        self.maleView.selected = YES;
        self.femaleView.selected = NO;
    }];
    [self.view addSubview:self.maleView];
    [self.maleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(45);
    }];
    self.femaleView = [[SexItemView alloc]init];
    self.femaleView.name = @"女";
    [self.femaleView setSelectionBlock:^{
        STRONG_SELF
        self.femaleView.selected = YES;
        self.maleView.selected = NO;
    }];
    [self.view addSubview:self.femaleView];
    [self.femaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.maleView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(45);
    }];
    
    self.maleView.selected = NO;
    self.femaleView.selected = NO;
    NSString *currentSex = [UserManager sharedInstance].userModel.sexName;
    if ([currentSex isEqualToString:self.maleView.name]) {
        self.maleView.selected = YES;
    }
    if ([currentSex isEqualToString:self.femaleView.name]) {
        self.femaleView.selected = YES;
    }
}

- (void)saveSex {
    NSString *name = nil;
    NSString *nameID = nil;
    if (self.maleView.selected) {
        nameID = @"1";
        name = @"男";
    }
    if (self.femaleView.selected) {
        nameID = @"0";
        name = @"女";
    }
    if (!name) {
        return;
    }
    [self.request stopRequest];
    self.request = [[UpdateUserInfoRequest alloc]init];
    self.request.sex = nameID;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].userModel.sexName = name;
        [UserManager sharedInstance].userModel.sexID = nameID;
        [[UserManager sharedInstance]saveData];
        BLOCK_EXEC(self.completeBlock);
        [self backAction];
    }];
}

@end
