//
//  MineCertiViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MineCertiViewController.h"
#import "MineCertiRequest.h"
#import "YXShowPhotosViewController.h"
#import "CertificateCell.h"
#import "CertificateHeaderView.h"
#import "MineCertiReadRequest.h"
#import "UserPromptsManager.h"
@interface MineCertiViewController ()
@property (nonatomic, strong) MineCertiRequest *certRequest;
@property (nonatomic, strong) MineCertiReadRequest *readRequest;
@property (nonatomic, strong) NSMutableArray *unReadArr;
@end

@implementation MineCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的证书";
    self.emptyView = [[EmptyView alloc]init];
    self.errorView = [[ErrorView alloc]init];
    [self setupUI];
    [self setupObserver];
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    self.tableView.rowHeight = 50;
    self.tableView.sectionHeaderHeight = 40;
    [self.tableView registerClass:[CertificateCell class] forCellReuseIdentifier:@"CertificateCell"];
}

- (void)firstPageFetch{
    [self.certRequest stopRequest];
    self.certRequest = [[MineCertiRequest alloc] init];
    self.certRequest.paltId = [UserManager sharedInstance].userModel.projectClassInfo.data.projectInfo.platId;
    self.unReadArr = [NSMutableArray array];
    WEAK_SELF
    [self.certRequest startRequestWithRetClass:[MineCertiRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        [self stopAnimation];
        if(error){
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            WEAK_SELF
            [self.errorView setRetryBlock:^{
                STRONG_SELF
                [self firstPageFetch];
            }];
            return;
        }
        NSInteger count = 0;
        MineCertiRequest_Item *item = (MineCertiRequest_Item *)retItem;
        for (MineCertiRequest_Item_clazsCertList *list in item.data.clazsCertList) {
            count += list.userCertList.count;
            for (MineCertiRequest_Item_userCertList *cert in list.userCertList) {
                if ([cert.hasRead isEqualToString:@"0"]) {
                    [self.unReadArr addObject:cert];
                }
            }
        }
        if (count == 0) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(@0);
            }];
            return;
        }
        self.dataArray = [NSMutableArray arrayWithArray:item.data.clazsCertList];
        [self.tableView reloadData];
    }];
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kReloadSignInRecordNotification" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MineCertiRequest_Item_clazsCertList *list = self.dataArray[section];
    return list.userCertList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CertificateCell"];
    MineCertiRequest_Item_clazsCertList *list = self.dataArray[indexPath.section];
    MineCertiRequest_Item_userCertList *elements = list.userCertList[indexPath.row];
    cell.elements = elements;
    cell.isLastRow = list.userCertList.count - 1 == indexPath.row;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CertificateHeaderView *header = [[CertificateHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 75)];
    header.certList = self.dataArray[section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXShowPhotosViewController *VC = [[YXShowPhotosViewController alloc] init];
    CertificateCell *cell = (CertificateCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setPointHidden];
    MineCertiRequest_Item_clazsCertList *list = self.dataArray[indexPath.section];
    MineCertiRequest_Item_userCertList *elements = list.userCertList[indexPath.row];
    NSString *imageUrl = [elements.certUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    VC.imageURLMutableArray = [NSMutableArray arrayWithObjects:imageUrl, nil];
    VC.animateRect = [self.view convertRect:cell.frame toView:self.view];
    [self.navigationController presentViewController:VC animated:YES completion:^{
        [self requestReadCertificateWithId:elements.certId];
    }];

}

- (void)requestReadCertificateWithId:(NSString *)resId{
    [self.readRequest stopRequest];
    self.readRequest = [[MineCertiReadRequest alloc] init];
    self.readRequest.certId = resId;
    [self.readRequest startRequestWithRetClass:[MineCertiReadRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {

    }];
    MineCertiRequest_Item_userCertList *removeCert;
    for (MineCertiRequest_Item_userCertList *cert in self.unReadArr) {
        if ([cert.certId isEqualToString:resId]) {
            removeCert = cert;
            break;
        }
    }
    [self.unReadArr removeObject:removeCert];
    if (self.unReadArr.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHasReadCertificateNotification object:nil];
    }
}

@end
