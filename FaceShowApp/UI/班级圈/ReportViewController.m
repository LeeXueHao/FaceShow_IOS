//
//  ReportViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"
#import "ReportRequest.h"

@interface ReportViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *reportTypeDesc;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SAMTextView *textView;

@property (nonatomic, strong) NSString *reportType;
@property (nonatomic, strong) ReportRequest *request;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.reportTypeDesc = @[@"色情低俗", @"广告骚扰", @"政治敏感", @"欺诈骗钱", @"违法（暴力恐惧、违禁品等）", @"其他"];
    
    [self setupNavigation];
    [self setupUI];
}

#pragma mark - setupNavigation
- (void)setupNavigation {
    self.navigationItem.title = @"举报";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"提交" action:^{
        STRONG_SELF
        if (isEmpty(self.reportType)) {
            [self.view nyx_showToast:@"未选择任何理由"];
            return;
        }
        [self reuqestReport];
    }];
}

- (void)reuqestReport {
    [self.request stopRequest];
    self.request = [[ReportRequest alloc] init];
    self.request.type = self.reportType;
    self.request.userId = self.userId;
    self.request.objectId = self.objectId;
    if (!isEmpty(self.textView.text)) {
        self.request.desc = self.textView.text;
    }
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[ReportRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        ReportRequestItem *item = (ReportRequestItem *)retItem;
        [self.view nyx_showToast:item.desc];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 49;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ReportTableViewCell class] forCellReuseIdentifier:@"ReportTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportTypeDesc.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportTableViewCell"];
    cell.textLabel.text = self.reportTypeDesc[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.reportType = [NSString stringWithFormat:@"%@", @(indexPath.row)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    header.textLabel.text = @"选择理由";
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [[UITableViewHeaderFooterView alloc] init];
    self.textView = [[SAMTextView alloc] init];
    self.textView.placeholder = @"请输入内容描述";
    [footer addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    return footer;
}

@end
