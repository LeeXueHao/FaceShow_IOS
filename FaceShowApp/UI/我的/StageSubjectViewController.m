//
//  StageSubjectViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectViewController.h"
#import "StageSubjectCell.h"
#import "UpdateUserInfoRequest.h"

@interface StageSubjectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) StageSubjectItem_Subject *selectedSubject;
@property (nonatomic, strong) UpdateUserInfoRequest *request;
@end

@implementation StageSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
}

- (void)updateUserInfo {
    [self.request stopRequest];
    self.request = [[UpdateUserInfoRequest alloc]init];
    self.request.stage = self.selectedStage.stageID;
    self.request.subject = self.selectedSubject.subjectID;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].userModel.stageID = self.selectedStage.stageID;
        [UserManager sharedInstance].userModel.stageName = self.selectedStage.name;
        [UserManager sharedInstance].userModel.subjectID = self.selectedSubject.subjectID;
        [UserManager sharedInstance].userModel.subjectName = self.selectedSubject.name;
        [[UserManager sharedInstance]saveData];
        BLOCK_EXEC(self.completeBlock);
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }];
}

#pragma mark - setupNavigation
- (void)setupNavigation {
    self.navigationItem.title = isEmpty(self.selectedStage) ? @"选择学段" : self.selectedStage.name;
    if (!isEmpty(self.selectedStage)) {
        WEAK_SELF
        [self nyx_setupRightWithTitle:@"确定" action:^{
            STRONG_SELF
            if (isEmpty(self.selectedSubject)) {
                [self.view nyx_showToast:@"请选择学科"];
                return;
            }
            [self updateUserInfo];
        }];
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 45;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[StageSubjectCell class] forCellReuseIdentifier:@"StageSubjectCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isEmpty(self.selectedStage) ? [UserManager sharedInstance].stages.count : self.selectedStage.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StageSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StageSubjectCell"];
    if (isEmpty(self.selectedStage)) {
        StageSubjectItem_Stage *stage = [UserManager sharedInstance].stages[indexPath.row];
        cell.textLabel.text = stage.name;
        cell.isLastRow = indexPath.row == [UserManager sharedInstance].stages.count-1;
    } else {
        StageSubjectItem_Subject *subject = self.selectedStage.subjects[indexPath.row];
        cell.textLabel.text = subject.name;
        cell.isLastRow = indexPath.row == self.selectedStage.subjects.count-1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEmpty(self.selectedStage)) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        StageSubjectViewController *vc = [[StageSubjectViewController alloc] init];
        StageSubjectItem_Stage *stage = [UserManager sharedInstance].stages[indexPath.row];
        vc.selectedStage = stage;
        WEAK_SELF
        vc.completeBlock = ^{
            STRONG_SELF
            BLOCK_EXEC(self.completeBlock);
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        StageSubjectItem_Subject *subject = self.selectedStage.subjects[indexPath.row];
        self.selectedSubject = subject;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    return header;
}

@end
