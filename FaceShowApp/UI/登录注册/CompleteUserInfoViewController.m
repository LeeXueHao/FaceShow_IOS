//
//  CompleteUserInfoViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CompleteUserInfoViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "UserInfoHeaderCell.h"
#import "UserInfoDefaultCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "YXImagePickerController.h"
#import "UserModel.h"
#import "UploadHeadImgRequest.h"
#import "UpdateAvatarRequest.h"
#import "ModifySexViewController.h"
#import "ModifyNameViewController.h"
#import "StageSubjectViewController.h"
#import "CompleteInfoHeaderView.h"
#import "MessagePromptView.h"
#import "AlertView.h"

@interface CompleteUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) NSMutableArray *contentMutableArray;
@end

@implementation CompleteUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"完善资料";
    [UserManager sharedInstance].userModel = [self.userItem toUserModel];
    self.contentMutableArray =
    [@[[@{@"title":@"姓名",@"content": [UserManager sharedInstance].userModel.realName?:@"暂无",@"next":@(YES)} mutableCopy],
       [@{@"title":@"联系电话",@"content":[UserManager sharedInstance].userModel.mobilePhone?:@"暂无"} mutableCopy],
       [@{@"title":@"性别",@"content":[UserManager sharedInstance].userModel.sexName?:@"暂无",@"next":@(YES)} mutableCopy],
       [@{@"title":@"学段学科",@"content":[self stageSubjectString]?:@"暂无",@"next":@(YES)} mutableCopy]] mutableCopy];
    [self setupUI];
    [self setupLayout];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showAlertWithMessage:[NSString stringWithFormat:@"成功加入【%@】！\n登录后即可查看到该班级。",self.className]];
    }];
    [self nyx_setupRightWithCustomView:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stageSubjectString {
    if (isEmpty([UserManager sharedInstance].userModel.stageName) || isEmpty([UserManager sharedInstance].userModel.subjectName)) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@-%@", [UserManager sharedInstance].userModel.stageName, [UserManager sharedInstance].userModel.subjectName];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.tableView registerClass:[UserInfoHeaderCell class] forCellReuseIdentifier:@"UserInfoHeaderCell"];
    [self.tableView registerClass:[UserInfoDefaultCell class] forCellReuseIdentifier:@"UserInfoDefaultCell"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.view addSubview:self.tableView];
    
    if (self.isYanXiuUser) {
        CompleteInfoHeaderView *headerView = [[CompleteInfoHeaderView alloc]init];
        CGFloat height = [headerView properHeight];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        self.tableView.tableHeaderView = headerView;
    }
}
- (void)setupLayout {
    //containerView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        ModifySexViewController *vc = [[ModifySexViewController alloc]init];
        WEAK_SELF
        [vc setCompleteBlock:^{
            STRONG_SELF
            [self.contentMutableArray[2] setValue:[UserManager sharedInstance].userModel.sexName forKey:@"content"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0) {
        ModifyNameViewController *vc = [[ModifyNameViewController alloc]init];
        WEAK_SELF
        [vc setCompleteBlock:^{
            STRONG_SELF
            [self.contentMutableArray[0] setValue:[UserManager sharedInstance].userModel.realName forKey:@"content"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3) {
        [TalkingData trackEvent:@"点击修改学段学科"];
        StageSubjectViewController *vc = [[StageSubjectViewController alloc] init];
        vc.selectedStageSubjectString = [self stageSubjectString];
        WEAK_SELF
        vc.completeBlock = ^{
            STRONG_SELF
            [self.contentMutableArray[3] setValue:[self stageSubjectString]?:@"暂无" forKey:@"content"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataScource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoDefaultCell" forIndexPath:indexPath];
    cell.contenDictionary = self.contentMutableArray[indexPath.section];
    return cell;
}

#pragma mark - save
- (void)showAlertWithMessage:(NSString *)message {
    MessagePromptView *promptView = [[MessagePromptView alloc]init];
    promptView.layer.cornerRadius = 7;
    promptView.clipsToBounds = YES;
    promptView.message = message;
    WEAK_SELF
    [promptView setConfirmBlock:^{
        STRONG_SELF
        [self.alertView hide];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.alertView = [[AlertView alloc]init];
    self.alertView.maskColor = [[UIColor colorWithHexString:@"333333"]colorWithAlphaComponent:.6];
    self.alertView.contentView = promptView;
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
        }];
    }];
}
@end
