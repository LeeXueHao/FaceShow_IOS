//
//  NBResourceListViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBResourceListViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "NBResourceListCell.h"
#import "NBGetResourceListRequest.h"
#import "ResourceDisplayViewController.h"
#import "GetResourceDetailRequest.h"
#import "UserPromptsManager.h"
#import "FSDataMappingTable.h"
#import "ResourceDownloadViewController.h"

@interface NBResourceListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NBGetResourceListRequest *listRequest;
@property (nonatomic, strong) NBGetResourceListRequestItem *item;
@property (nonatomic, strong) GetResourceDetailRequest *detailRequest;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation NBResourceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestResourceInfo];
    [self setupObserver];

}

- (void)setupObserver{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHasNewResourceNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.mainVC.selectedIndex == 1) {
            [UserPromptsManager sharedInstance].resourceNewView.hidden = YES;
            [self requestResourceInfo];
        }
    }];
}


- (void)requestResourceInfo{
    [self.view nyx_startLoading];
    [self.listRequest stopRequest];
    self.listRequest = [[NBGetResourceListRequest alloc] init];
    self.listRequest.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    self.listRequest.tagId = self.tagId;
    WEAK_SELF
    [self.listRequest startRequestWithRetClass:[NBGetResourceListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return ;
        }
        NBGetResourceListRequestItem *item = (NBGetResourceListRequestItem *)retItem;
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
        ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc] init];
        vc.urlString = sourceURL;
        vc.name = item.data.resName;
        vc.showDownloadNavView = isAttachment;
        vc.downloadUrl = item.data.ai.downloadUrl;
        vc.resourceId = item.data.ai.resId;
        vc.needDownload = isAttachment && [FSDataMappingTable ResourceTypeWithKey:item.data.ai.resType] != ResourceType_Image;
        vc.showDownloadNavView = [UserManager sharedInstance].configItem.data.resourceDown;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


#pragma mark - setupUI
- (void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 61;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NBResourceListCell class] forCellReuseIdentifier:@"NBResourceListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(5);
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

#pragma mark - RefreshDelegate
- (void)refreshUI{
    [self requestResourceInfo];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.item.data.tagList.count + self.item.data.resList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBResourceListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"NBResourceListCell"];
    if (indexPath.row < self.item.data.tagList.count) {
        listCell.tagList = self.item.data.tagList[indexPath.row];
    }else{
        listCell.resList = self.item.data.resList[indexPath.row - self.item.data.tagList.count];
    }
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.item.data.tagList.count) {
        //跳转下级页面
        NBResourceListViewController *resListVC = [[NBResourceListViewController alloc] init];
        NBGetResourceListRequestItem_tagList *tag = self.item.data.tagList[indexPath.row];
        resListVC.tagId = tag.taglistId;
        resListVC.title = tag.name;
        [self.navigationController pushViewController:resListVC animated:YES];
    }else{
        NBGetResourceListRequestItem_resList *resList = self.item.data.resList[indexPath.row - self.item.data.tagList.count];
        [self requestResourceDetailWithResId:resList.resId];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
