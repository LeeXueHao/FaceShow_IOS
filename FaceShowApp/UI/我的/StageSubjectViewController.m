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

static  NSString *const kStageNavigationItemtitle = @"选择学段";

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isEmpty(self.selectedStage)) {
        [self setDefaultStage];
    }else{
        [self setDefaultSubject];
    }

}

-(void)setDefaultStage{
    NSString *currentStage = [self.selectedStageSubjectString componentsSeparatedByString:@"-"].firstObject;
    for (int i = 0; i < [UserManager sharedInstance].stages.count; i ++) {
        StageSubjectItem_Stage *stage = [UserManager sharedInstance].stages[i];
        if ([stage.name isEqualToString:currentStage]) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
            return;
        }
    }
}

-(void)setDefaultSubject{
    NSString *currentStage = [self.selectedStageSubjectString componentsSeparatedByString:@"-"].firstObject;
    if (![currentStage isEqualToString:self.selectedStage.name]) {
        return;
    }else{
        NSString *currentSubject = [self.selectedStageSubjectString componentsSeparatedByString:@"-"].lastObject;
        for (int i = 0; i < self.selectedStage.subjects.count; i ++) {
            StageSubjectItem_Subject *subject = self.selectedStage.subjects[i];
            if ([subject.name isEqualToString:currentSubject]) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
                return;
            }
        }
    }


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
        NSInteger index = self.navigationController.viewControllers.count-3;
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
    }];
}

#pragma mark - setupNavigation
- (void)setupNavigation {
    self.navigationItem.title = isEmpty(self.selectedStage) ? kStageNavigationItemtitle : self.selectedStage.name;
    if (!isEmpty(self.selectedStage)) {
        WEAK_SELF
        [self nyx_setupRightWithTitle:@"确定" action:^{
            STRONG_SELF
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (isEmpty(indexPath)) {
                [self.view nyx_showToast:@"请选择学科"];
                return;
            }else{
                self.selectedSubject = self.selectedStage.subjects[indexPath.row];
            }
            if (isEmpty(self.selectedSubject)) {
                [self.view nyx_showToast:@"请选择学科"];
                return;
            }
            [self updateUserInfo];
        }];
    }else {
        WEAK_SELF
        [self nyx_setupRightWithTitle:@"下一步" action:^{
            STRONG_SELF
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            self.selectedStage = [UserManager sharedInstance].stages[indexPath.row];
            if (isEmpty(self.selectedStage)) {
                [self.view nyx_showToast:@"请选择学段"];
                return;
            }
            StageSubjectViewController *vc = [[StageSubjectViewController alloc] init];
            vc.selectedStage = self.selectedStage;
            vc.selectedStageSubjectString = self.selectedStageSubjectString;
            WEAK_SELF
            vc.completeBlock = ^{
                STRONG_SELF
                BLOCK_EXEC(self.completeBlock);
            };
            [self.navigationController pushViewController:vc animated:YES];
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
    if ([self.navigationItem.title isEqualToString:kStageNavigationItemtitle]) {
        StageSubjectItem_Stage *stage = [UserManager sharedInstance].stages[indexPath.row];
        self.selectedStage = stage;
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
