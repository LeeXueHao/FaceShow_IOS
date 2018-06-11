//
//  TaskListViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskCell.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "GetTaskRequest.h"
#import "FSDataMappingTable.h"
#import "QuestionnaireResultViewController.h"
#import "QuestionnaireViewController.h"
#import "GetSigninRequest.h"
#import "SignInDetailViewController.h"
#import "UserPromptsManager.h"
#import "YXDrawerController.h"
#import "MJRefresh.h"

@interface TaskListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) GetTaskRequest *request;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) GetSigninRequest *getSigninRequest;
@property (nonatomic, strong) GetSignInRecordListRequestItem_SignIn *signIn;
@end

@implementation TaskListViewController

- (void)dealloc {
    [self.header free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    [self setupUI];
    [self setupObserver];
    [self requestTaskInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestTaskInfo {
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request stopRequest];
    self.request = [[GetTaskRequest alloc] init];
    self.request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    [self.request startRequestWithRetClass:[GetTaskRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.header endRefreshing];
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetTaskRequestItem *item = (GetTaskRequestItem *)retItem;
        if (isEmpty(item.data)) {
            self.emptyView.hidden = NO;
            return;
        }
        self.dataArray = [NSArray arrayWithArray:item.data];
        [self.tableView reloadData];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TaskCell class] forCellReuseIdentifier:@"TaskCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无任务";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestTaskInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestTaskInfo];
    };
}

#pragma mark - Observer
- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kReloadSignInRecordNotification" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        NSDictionary *dic = (NSDictionary *)x.object;
        NSIndexPath *currentIndex = [dic objectForKey:@"kSignInRecordCurrentIndexPath"];
//        NSString *signInTime = [dic valueForKey:@"kCurrentIndexPathSucceedSigninTime"];
//        GetSignInRecordListRequestItem_SignIn *signIn = self.signIn;
//        GetSignInRecordListRequestItem_UserSignIn *userSignIn = [GetSignInRecordListRequestItem_UserSignIn new];
//        userSignIn.signinTime = signInTime;
//        signIn.userSignIn = userSignIn;
        GetTaskRequestItem_Task *task = self.dataArray[currentIndex.row];
        task.stepFinished = @"1";
        [self.tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.task = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetTaskRequestItem_Task *task = self.dataArray[indexPath.row];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:task.interactType];
    if (type == InteractType_Vote) {
        if (task.stepFinished.boolValue) {
            QuestionnaireResultViewController *vc = [[QuestionnaireResultViewController alloc]initWithStepId:task.stepId];
            vc.name = task.interactName;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:task.stepId interactType:type];
            vc.name = task.interactName;
            WEAK_SELF
            [vc setCompleteBlock:^{
                STRONG_SELF
                task.stepFinished = @"1";
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self checkIfHasUncompleteTask];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (type == InteractType_Questionare) {
        QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:task.stepId interactType:type];
        vc.name = task.interactName;
        WEAK_SELF
        [vc setCompleteBlock:^{
            STRONG_SELF
            task.stepFinished = @"1";
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self checkIfHasUncompleteTask];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_SignIn) {
        [self.getSigninRequest stopRequest];
        self.getSigninRequest = [[GetSigninRequest alloc]init];
        self.getSigninRequest.stepId = task.stepId;
        WEAK_SELF
        [self.view nyx_startLoading];
        [self.getSigninRequest startRequestWithRetClass:[GetSigninRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            GetSigninRequestItem *item = retItem;
            SignInDetailViewController *signInDetailVC = [[SignInDetailViewController alloc] init];
            signInDetailVC.signIn = item.data.signIn;
            signInDetailVC.currentIndexPath = indexPath;
            [self.navigationController pushViewController:signInDetailVC animated:YES];
        }];
    }
}

- (void)checkIfHasUncompleteTask {
    for (GetTaskRequestItem_Task *task in self.dataArray) {
        InteractType type = [FSDataMappingTable InteractTypeWithKey:task.interactType];
        if (task.stepFinished.integerValue!=1 && (type==InteractType_Vote || type==InteractType_Questionare)) {
            return;
        }
    }
    [UserPromptsManager sharedInstance].taskNewView.hidden = YES;
}

@end
