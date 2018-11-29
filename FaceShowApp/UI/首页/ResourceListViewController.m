//
//  ResourceListViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceListViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "ResourceCell.h"
#import "GetResourceListRequest.h"
#import "YXResourceDisplayViewController.h"
#import "GetResourceDetailRequest.h"
#import "UserPromptsManager.h"
#import "FSDataMappingTable.h"
#import "ResourceDownloadViewController.h"

@interface ResourceListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetResourceListRequest *listRequest;
@property (nonatomic, strong) GetResourceListRequestItem *item;
@property (nonatomic, strong) GetResourceDetailRequest *detailRequest;
@end

@implementation ResourceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestResourceInfo];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewResourceNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.mainVC.selectedIndex == 1) {
            [UserPromptsManager sharedInstance].resourceNewView.hidden = YES;
            [self requestResourceInfo];
        }
    }];
}

- (void)requestResourceInfo {
    [self.view nyx_startLoading];
    [self.listRequest stopRequest];
    self.listRequest = [[GetResourceListRequest alloc] init];
    self.listRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    self.listRequest.tagId = self.tagId;
    WEAK_SELF
    [self.listRequest startRequestWithRetClass:[GetResourceListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return ;
        }
        GetResourceListRequestItem *item = (GetResourceListRequestItem *)retItem;
        if (isEmpty(item.data.tagList) && isEmpty(item.data.resList)) {
            self.emptyView.hidden = NO;
            return;
        }
        self.item = item;
        [self.tableView reloadData];
    }];
}

- (void)requestResourceDetailWithResId:(NSString *)resId {
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.detailRequest stopRequest];
    self.detailRequest = [[GetResourceDetailRequest alloc] init];
    self.detailRequest.resId = resId;
    [self.detailRequest startRequestWithRetClass:[GetResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];;
            return;
        }
        GetResourceDetailRequestItem *item = (GetResourceDetailRequestItem *)retItem;
        BOOL isAttachment = item.data.type.integerValue == 0;
        NSString *sourceURL = isAttachment ? item.data.ai.previewUrl : item.data.url;
        YXResourceDisplayViewController *vc = [[YXResourceDisplayViewController alloc] init];
        vc.urlString = sourceURL;
        vc.name = item.data.resName;
        vc.downloadUrl = item.data.ai.downloadUrl;
        vc.resourceId = item.data.ai.resId;
        vc.needDownload = isAttachment && [FSDataMappingTable ResourceTypeWithKey:item.data.ai.resType] != ResourceType_Image;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ResourceCell class] forCellReuseIdentifier:@"ResourceCell"];
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无资源";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestResourceInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.data.tagList.count + self.item.data.resList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceCell"];
    if (indexPath.row < self.item.data.tagList.count) {
        cell.tagList = self.item.data.tagList[indexPath.row];
    }else{
        cell.resList = self.item.data.resList[indexPath.row - self.item.data.tagList.count];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.item.data.tagList.count) {
        //跳转下级页面
        ResourceListViewController *resListVC = [[ResourceListViewController alloc] init];
        GetResourceListRequestItem_tagList *tag = self.item.data.tagList[indexPath.row];
        resListVC.tagId = tag.taglistId;
        resListVC.title = tag.name;
        [self.navigationController pushViewController:resListVC animated:YES];
    }else{
        GetResourceListRequestItem_resList *resList = self.item.data.resList[indexPath.row - self.item.data.tagList.count];
        [self requestResourceDetailWithResId:resList.resId];
    }
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
    NSLog(@"refresh called!");
    [self requestResourceInfo];
}

@end
