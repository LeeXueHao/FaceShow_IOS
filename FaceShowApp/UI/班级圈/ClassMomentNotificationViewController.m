//
//  ClassMomentNotificationViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentNotificationViewController.h"
#import "ClassMomentUserMomentMsgRequest.h"
#import "ClassMomentNotificationCell.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "ClassMomentDetailViewController.h"

@interface ClassMomentNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) ClassMomentUserMomentMsgRequest *messageRequest;
@end

@implementation ClassMomentNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    [self setupUI];
    [self requestForUserMomentMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ClassMomentNotificationCell class] forCellReuseIdentifier:@"ClassMomentNotificationCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无消息";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForUserMomentMsg];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassMomentNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassMomentNotificationCell"];
    cell.message = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassMomentUserMomentMsgItem_Data_Msg *message = self.dataArray[indexPath.row];
    ClassMomentDetailViewController *VC = [[ClassMomentDetailViewController alloc] init];
    VC.momentId = message.momentId;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - request
- (void)requestForUserMomentMsg {
    [self.view nyx_startLoading];
    WEAK_SELF
    ClassMomentUserMomentMsgRequest *request = [[ClassMomentUserMomentMsgRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    [request startRequestWithRetClass:[ClassMomentUserMomentMsgItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        ClassMomentUserMomentMsgItem *item = retItem;
        if (isEmpty(item.data)) {
            self.emptyView.hidden = NO;
            return;
        }
        BLOCK_EXEC(self.classMomentNotificationReloadBlock);
        self.dataArray = [NSArray arrayWithArray:item.data.msgs];
        [self.tableView reloadData];
    }];
    self.messageRequest = request;
}
@end
