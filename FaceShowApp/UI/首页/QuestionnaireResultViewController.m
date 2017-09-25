//
//  QuestionnaireResultViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionnaireResultViewController.h"
#import "ChooseQuestionResultCell.h"
#import "FillQuestionResultCell.h"
#import "GetVoteRequest.h"
#import "QuestionRequestItem.h"
#import "ErrorView.h"
#import "FSDataMappingTable.h"
#import "QuestionnaireViewController.h"
#import "QuestionnaireHeaderView.h"

@interface QuestionnaireResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) GetVoteRequest *voteRequest;
@property (nonatomic, strong) QuestionRequestItem *requestItem;
@end

@implementation QuestionnaireResultViewController

- (instancetype)initWithStepId:(NSString *)stepId {
    if (self = [super init]) {
        self.stepId = stepId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"投票";
    [self setupUI];
    [self requestVoteInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *preVC = array[array.count-2];
    if ([preVC isKindOfClass:[QuestionnaireViewController class]]) {
        [self.navigationController popToViewController:array[array.count-3] animated:YES];
    }else {
        [super backAction];
    }
}

- (void)requestVoteInfo {
    [self.voteRequest stopRequest];
    self.voteRequest = [[GetVoteRequest alloc]init];
    self.voteRequest.stepId = self.stepId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.voteRequest startRequestWithRetClass:[QuestionRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.requestItem = retItem;
        [self.tableView reloadData];
    }];
}

- (void)setupUI {
    CGFloat height = [QuestionnaireHeaderView heightForTitle:self.name];
    QuestionnaireHeaderView *headerView = [[QuestionnaireHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    headerView.title = self.name;
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = headerView;
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
    [self.tableView registerClass:[FillQuestionResultCell class] forCellReuseIdentifier:@"FillQuestionResultCell"];
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestVoteInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requestItem.data.questionGroup.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionRequestItem_question *question = self.requestItem.data.questionGroup.questions[indexPath.row];
    QuestionType type = [FSDataMappingTable QuestionTypeWithKey:question.questionType];
    if (type==QuestionType_SingleChoose || type==QuestionType_MultiChoose) {
        ChooseQuestionResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQuestionResultCell"];
        cell.index = indexPath.row+1;
        cell.item = question;
        cell.bottomLineHidden = indexPath.row==self.requestItem.data.questionGroup.questions.count;
        return cell;
    }
    if (type == QuestionType_Fill) {
        FillQuestionResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FillQuestionResultCell"];
        cell.index = indexPath.row+1;
        cell.currentTime = self.requestItem.currentTime;
        cell.item = question;
        cell.bottomLineHidden = indexPath.row==self.requestItem.data.questionGroup.questions.count;
        return cell;
    }
    return nil;
}

@end
