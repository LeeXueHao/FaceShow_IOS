//
//  SignInRecordViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInRecordViewController.h"
#import "SignInRecordCell.h"
#import "SignInRecordHeaderView.h"
#import "SignInDetailViewController.h"
#import "GetSignInRecordListFetcher.h"
#import "GetSignInRecordListRequest.h"
#import "GetSigninRequest.h"
#import "EmptySignInRecordCell.h"

@interface SignInRecordViewController ()
@property (nonatomic, strong) GetSigninRequest *getSigninRequest;
@end

@implementation SignInRecordViewController

- (void)viewDidLoad {
    GetSignInRecordListFetcher *fetcher = [[GetSignInRecordListFetcher alloc] init];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.title = @"签到记录";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[SignInRecordCell class] forCellReuseIdentifier:@"SignInRecordCell"];
    [self.tableView registerClass:[EmptySignInRecordCell class] forCellReuseIdentifier:NSStringFromClass([EmptySignInRecordCell class])];
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kReloadSignInRecordNotification" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        NSDictionary *dic = (NSDictionary *)x.object;
        NSIndexPath *currentIndex = [dic objectForKey:@"kSignInRecordCurrentIndexPath"];
        NSString *signInTime = [dic valueForKey:@"kCurrentIndexPathSucceedSigninTime"];
        GetSignInRecordListRequestItem_Element *element = self.dataArray[currentIndex.section];
        GetSignInRecordListRequestItem_SignIn *signIn = element.signIns[currentIndex.row];
        GetSignInRecordListRequestItem_UserSignIn *userSignIn = [GetSignInRecordListRequestItem_UserSignIn new];
        userSignIn.signinTime = signInTime;
        signIn.userSignIn = userSignIn;
        [self.tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GetSignInRecordListRequestItem_Element *element = self.dataArray[indexPath.section];
    if (element.signIns.count > 0) {
        SignInRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInRecordCell"];
        cell.hasBottomLine = indexPath.row != element.signIns.count - 1;
        cell.signIn = element.signIns[indexPath.row];
        return cell;
    }
    
    EmptySignInRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptySignInRecordCell class])];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GetSignInRecordListRequestItem_Element *element = self.dataArray[section];
    return element.signIns.count > 0 ? element.signIns.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GetSignInRecordListRequestItem_Element *element = self.dataArray[section];
    SignInRecordHeaderView *headerView = [[SignInRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 75)];
    headerView.projectName = element.projectName;
    headerView.clazzName = element.clazs.clazsName;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetSignInRecordListRequestItem_Element *element = self.dataArray[indexPath.section];
    if (element.signIns.count > 0) {
        GetSignInRecordListRequestItem_SignIn *signIn = element.signIns[indexPath.row];
        [self getSignInDetailWithStepId:signIn.stepId indexPath:indexPath];
    }
}

- (void)getSignInDetailWithStepId:(NSString *)stepId indexPath:(NSIndexPath *)indexPath{
    [self.getSigninRequest stopRequest];
    self.getSigninRequest = [[GetSigninRequest alloc]init];
    self.getSigninRequest.stepId = stepId;
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
        item.data.signIn.stepId = stepId;
        SignInDetailViewController *signInDetailVC = [[SignInDetailViewController alloc] init];
        signInDetailVC.signIn = item.data.signIn;
        signInDetailVC.currentIndexPath = indexPath;
        [self.navigationController pushViewController:signInDetailVC animated:YES];
    }];
}

@end
