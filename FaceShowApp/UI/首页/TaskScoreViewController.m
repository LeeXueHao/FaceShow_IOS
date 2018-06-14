//
//  TaskScoreViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskScoreViewController.h"
#import "TaskTopView.h"
#import "TaskNameCell.h"
#import "ErrorView.h"

@interface TaskScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ErrorView *errorView;
@property(nonatomic, strong) TaskTopView *topView;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TaskScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.topView = [[TaskTopView alloc]init];
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
    tipLabel.text = @"进度详情";
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
    [self.tableView registerClass:[TaskNameCell class] forCellReuseIdentifier:@"TaskNameCell"];
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
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskNameCell"];
//    cell.task = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;//self.dataArray.count;
}

- (void)refreshUI {
    
}
@end
