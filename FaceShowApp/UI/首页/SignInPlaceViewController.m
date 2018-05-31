//
//  SignInPlaceViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/5/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPlaceViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "SignInPLaceCell.h"

@interface SignInPlaceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
//@property (nonatomic, strong) GetResourceRequest *request;
//@property (nonatomic, strong) GetResourceDetailRequest *detailRequest;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SignInPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置签到";
    [self setupUI];
    [self requestSignInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {    
    UIView *titleBgView = [[UIView alloc]init];
    titleBgView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.font = [UIFont boldSystemFontOfSize:14];
    titleLable.textColor = [UIColor colorWithHexString:@"999999"];
    titleLable.text = @"当前可签到:";
    [titleBgView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SignInPLaceCell class] forCellReuseIdentifier:@"SignInPLaceCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleBgView.mas_bottom);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无资源";
//    [self.view addSubview:self.emptyView];
//    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
//        [self requestResourceInfo];
    }];
//    [self.view addSubview:self.errorView];
//    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
}

- (void)requestSignInfo {
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;//self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInPLaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInPLaceCell"];
//    cell.data = self.dataArray[indexPath.row];
    WEAK_SELF
    [cell setSignInPlaceBlock:^{
        STRONG_SELF
        [self.view nyx_showToast:@"请求签到"];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

@end
