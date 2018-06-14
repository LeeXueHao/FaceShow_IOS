//
//  StudyScoreViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "StudyScoreViewController.h"
#import "ScoreTopView.h"
#import "ScoreNameCell.h"
#import "ErrorView.h"
#import "GetUserClazsScoreRequest.h"

@interface StudyScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ErrorView *errorView;
@property(nonatomic, strong) ScoreTopView *topView;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GetUserClazsScoreRequest *request;
@property (nonatomic, strong) GetUserClazsScoreRequestItem *item;
@property (nonatomic, assign) BOOL isLayoutComplete;
@end

@implementation StudyScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestUserScore];
    }];
    [self requestUserScore];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.topView = [[ScoreTopView alloc]init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(170);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.font = [UIFont boldSystemFontOfSize:14];
    tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
    tipLabel.text = @"得分明细";
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ScoreNameCell class] forCellReuseIdentifier:@"ScoreNameCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

- (void)requestUserScore {
    [self.request stopRequest];
    self.request = [[GetUserClazsScoreRequest alloc]init];
    self.request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[GetUserClazsScoreRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        [self.errorView removeFromSuperview];
        if (!self.isLayoutComplete) {
            [self setupUI];
            self.isLayoutComplete = YES;
        }
        self.item = retItem;
        self.topView.item = self.item;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreNameCell"];
    cell.item = self.item.data.userScore.userScoreItems[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.data.userScore.userScoreItems.count;
}

- (void)refreshUI {
    [self requestUserScore];
}
@end
