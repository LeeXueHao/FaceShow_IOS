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

@interface SignInRecordViewController ()
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
    SignInRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInRecordCell"];
    GetSignInRecordListRequestItem_Element *element = self.dataArray[indexPath.section];
    cell.hasBottomLine = indexPath.row != element.signIns.count - 1;
    cell.signIn = element.signIns[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GetSignInRecordListRequestItem_Element *element = self.dataArray[section];
    return element.signIns.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
    SignInDetailViewController *signInDetailVC = [[SignInDetailViewController alloc] init];
    GetSignInRecordListRequestItem_Element *element = self.dataArray[indexPath.section];
    signInDetailVC.signIn = element.signIns[indexPath.row];
    signInDetailVC.currentIndexPath = indexPath;
    [self.navigationController pushViewController:signInDetailVC animated:YES];
}

@end
