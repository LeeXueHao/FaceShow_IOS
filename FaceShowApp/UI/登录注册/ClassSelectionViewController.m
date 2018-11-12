//
//  ClassSelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassSelectionViewController.h"
#import "ClassListCell.h"
#import "ClassListRequest.h"
#import "EmptyView.h"
#import "GetCurrentClazsRequest.h"
#import "GetStudentClazsRequest.h"
#import "AppUseRecordManager.h"
#import "GetClassConfigRequest.h"

@interface ClassSelectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ClassListRequestItem_clazsInfos *selectedClass;
@property (nonatomic, strong) ClassListRequestItem *clazsListItem;
@property (nonatomic, strong) ClassListRequest *getClassRequest;
@property (nonatomic, strong) GetStudentClazsRequest *clazsRefreshRequest;
@property (nonatomic, strong) GetClassConfigRequest *getClassConfigRequest;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ClassSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    [self requestClasses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupNav
- (void)setupNav {
    self.title = @"选择班级";
    
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightBtn.frame = CGRectMake(0, 0, 40, 30);
    self.navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navRightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.navRightBtn addTarget:self action:@selector(navRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn.enabled = !isEmpty(self.selectedClass);
    [self nyx_setupRightWithCustomView:self.navRightBtn];
}

- (void)navRightBtnAction:(UIButton *)sender {
    [self updateClazsInfo];
}

- (void)updateClazsInfo {

    [self.view nyx_startLoading];
    [self.clazsRefreshRequest stopRequest];
    self.clazsRefreshRequest = [[GetStudentClazsRequest alloc] init];
    self.clazsRefreshRequest.clazsId = self.selectedClass.clazsId;
    WEAK_SELF
    [self.clazsRefreshRequest startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        GetCurrentClazsRequestItem *item = retItem;
        //使用情况统计
        AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
        request.actionType = AppUseRecordActionType_GetStudentClazs;
        [[AppUseRecordManager sharedInstance]addRecord:request];
        [UserManager sharedInstance].userModel.projectClassInfo = item;
        [[UserManager sharedInstance]saveData];
        [UserManager sharedInstance].hasUsedBefore = YES;
        if([item.data.clazsInfo.modelId isEqualToString:@"0"]){
            [self.view nyx_stopLoading];
            [UserManager sharedInstance].configItem = nil;
            [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
        }else{
            [self.getClassConfigRequest stopRequest];
            self.getClassConfigRequest = [[GetClassConfigRequest alloc] init];
            self.getClassConfigRequest.modleId = item.data.clazsInfo.modelId;
            WEAK_SELF
            [self.getClassConfigRequest startRequestWithRetClass:[GetClassConfigRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                STRONG_SELF
                if (error) {
                    [self.view nyx_showToast:error.localizedDescription];
                    return;
                }
                [self.view nyx_stopLoading];
                [UserManager sharedInstance].configItem = (GetClassConfigRequest_Item *)retItem;
                [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
            }];
        }
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableview = [[UITableView alloc]init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableview.allowsMultipleSelection = NO;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableview registerClass:[ClassListCell class] forCellReuseIdentifier:@"ClassListCell"];
}

#pragma mark - Request
- (void)requestClasses {
    [self.getClassRequest stopRequest];
    self.getClassRequest = [[ClassListRequest alloc]init];
    self.getClassRequest.projectId = [UserManager sharedInstance].userModel.projectClassInfo.data.projectInfo.projectId;
    self.getClassRequest.userId = [UserManager sharedInstance].userModel.userID;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.getClassRequest startRequestWithRetClass:[ClassListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        ClassListRequestItem *item = (ClassListRequestItem *)retItem;
        self.clazsListItem = item;
        NSString *clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
        for (ClassListRequestItem_clazsInfos *info in item.data.clazsInfos) {
            if ([info.clazsId isEqualToString:clazsId]) {
                self.selectedIndex = [item.data.clazsInfos indexOfObject:info];
                self.selectedClass = info;
                break;
            }
        }
        if (!self.selectedClass) {
            self.selectedIndex = 0;
            self.selectedClass = item.data.clazsInfos.firstObject;
        }
        [self.tableview reloadData];
        if (item.data.clazsInfos.count > 0) {
            self.navRightBtn.enabled = YES;
        }
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clazsListItem.data.clazsInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassListCell"];
    ClassListRequestItem_clazsInfos *info = self.clazsListItem.data.clazsInfos[indexPath.row];
    cell.classInfo = info;
    if (indexPath.row == self.selectedIndex) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedClass = self.clazsListItem.data.clazsInfos[indexPath.row];
    self.selectedIndex = indexPath.row;
    self.navRightBtn.enabled = !isEmpty(self.selectedClass);
}

- (void)refreshClasses {
    [self requestClasses];
}
@end
