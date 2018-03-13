//
//  CourseResourceViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResourceViewController.h"
#import "EmptyView.h"
#import "CourseCatalogCell.h"
#import "ResourceDisplayViewController.h"
#import "GetResourceDetailRequest.h"
#import "ResourceTypeMapping.h"

@interface CourseResourceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) GetResourceDetailRequest *request;
@end

@implementation CourseResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController.navigationBarHidden) {
        return;
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)setAttachmentInfos:(NSArray<GetCourseRequestItem_AttachmentInfo,Optional> *)attachmentInfos {
    _attachmentInfos = attachmentInfos;
    [self.tableView reloadData];
    if (attachmentInfos.count == 0) {
        self.emptyView.hidden = NO;
    }
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 59;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseCatalogCell class] forCellReuseIdentifier:@"CourseCatalogCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    if (self.attachmentInfos.count == 0) {
        self.emptyView.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attachmentInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogCell"];
    GetCourseRequestItem_AttachmentInfo *info = self.attachmentInfos[indexPath.row];
    cell.title = info.resName;
    cell.iconName = [ResourceTypeMapping resourceTypeWithString:info.resType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetCourseRequestItem_AttachmentInfo *data = self.attachmentInfos[indexPath.row];
    [self requestResourceDetailWithResId:data.resId];
}

- (void)requestResourceDetailWithResId:(NSString *)resId {
    [self.request stopRequest];
    self.request = [[GetResourceDetailRequest alloc]init];
    self.request.resId = resId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        GetResourceDetailRequestItem *item = (GetResourceDetailRequestItem *)retItem;
        ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc]init];
        if (item.data.type.integerValue > 0) {
            vc.urlString = item.data.url;
            vc.name = item.data.resName;
        }else {
            vc.urlString = item.data.ai.previewUrl;
            vc.name = item.data.ai.resName;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
