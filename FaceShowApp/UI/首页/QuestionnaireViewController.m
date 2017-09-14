//
//  QuestionnaireViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "ChooseQuestionCell.h"
#import "FillQuestionCell.h"

@interface QuestionnaireViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[ChooseQuestionCell class] forCellReuseIdentifier:@"ChooseQuestionCell"];
    [self.tableView registerClass:[FillQuestionCell class] forCellReuseIdentifier:@"FillQuestionCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQuestionCell"];
    cell.optionArray = @[@"aaaaaaaaaaaaa111",
                         @"bbbbbdbfoifoegnoegnognowengoewngowenogwenogewnognoewgnowengiowegoweng222",
                         @"方便发你哦 供你热工农了333",
                         @"费二狗我个人弄内购gingNo工农人个人饿哦工日 个还给你N割肉给根荣格尼尔 盖聂弄个人 工农而个侬玩偶尔发我444"];
    cell.bottomLineHidden = indexPath.row==9;
    return cell;
}

@end
