//
//  QuestionnaireResultViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionnaireResultViewController.h"
#import "ChooseQuestionResultCell.h"

@interface QuestionnaireResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QuestionnaireResultViewController

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
    [self.tableView registerClass:[ChooseQuestionResultCell class] forCellReuseIdentifier:@"ChooseQuestionResultCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseQuestionResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQuestionResultCell"];
    OptionResult *r1 = [self optionResultWithOption:@"aaaaaaaaaaaaa111" rate:0.1];
    OptionResult *r2 = [self optionResultWithOption:@"bbbbbdbfoifoegnoegnognowengoewngowenogwenogewnognoewgnowengiowegoweng222" rate:0.2];
    OptionResult *r3 = [self optionResultWithOption:@"方便发你哦 供你热工农了333" rate:0.3];
    OptionResult *r4 = [self optionResultWithOption:@"费二狗我个人弄内购gingNo工农人个人饿哦工日 个还给你N割肉给根荣格尼尔 盖聂弄个人 工农而个侬玩偶尔发我444" rate:0.4];
    cell.optionArray = @[r1,r2,r3,r4];
    cell.bottomLineHidden = indexPath.row==9;
    return cell;
}

- (OptionResult *)optionResultWithOption:(NSString *)option rate:(CGFloat)rate {
    OptionResult *r = [[OptionResult alloc]init];
    r.option = option;
    r.rate = rate;
    return r;
}

@end
