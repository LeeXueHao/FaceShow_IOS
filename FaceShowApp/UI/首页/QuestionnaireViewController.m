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
#import "GetVoteRequest.h"
#import "GetQuestionnaireRequest.h"
#import "QuestionRequestItem.h"
#import "ErrorView.h"
#import "SaveUserVoteRequest.h"
#import "SaveUserQuestionnaireRequest.h"
#import "QuestionnaireResultViewController.h"
#import "QuestionnaireHeaderView.h"
#import "GetEvaluateRequest.h"
#import "SaveUserEvaluateRequest.h"

@interface QuestionnaireViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetVoteRequest *voteRequest;
@property (nonatomic, strong) GetQuestionnaireRequest *questionnaireRequest;
@property(nonatomic, strong) GetEvaluateRequest *evaluateRequest;
@property (nonatomic, strong) QuestionRequestItem *requestItem;
@property (nonatomic, strong) SaveUserVoteRequest *saveVoteRequest;
@property (nonatomic, strong) SaveUserQuestionnaireRequest *saveQuestionnaireRequest;
@property(nonatomic, strong) SaveUserEvaluateRequest *saveEvaluateRequest;
@end

@implementation QuestionnaireViewController

- (instancetype)initWithStepId:(NSString *)stepId interactType:(InteractType)type {
    if (self = [super init]) {
        self.stepId = stepId;
        self.interactType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.interactType == InteractType_Vote) {
        self.navigationItem.title = @"投票";
    }else if (self.interactType == InteractType_Evaluate) {
        self.navigationItem.title = @"评价";
    }else {
        self.navigationItem.title = @"问卷";
    }
    [self setupUI];
    [self setupObservers];
    [self requestPaperInfo];
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

- (void)requestPaperInfo {
    if (self.interactType == InteractType_Vote) {
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
                if ([self isNetworkReachable]) {
                    [self.view nyx_showToast:error.localizedDescription];
                    return;
                }
                self.errorView.hidden = NO;
                return;
            }
            [self refreshUIWithItem:retItem];
        }];
    }else if (self.interactType == InteractType_Evaluate) {
        [self.evaluateRequest stopRequest];
        self.evaluateRequest = [[GetEvaluateRequest alloc]init];
        self.evaluateRequest.stepId = self.stepId;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.evaluateRequest startRequestWithRetClass:[QuestionRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            self.errorView.hidden = YES;
            if (error) {
                if ([self isNetworkReachable]) {
                    [self.view nyx_showToast:error.localizedDescription];
                    return;
                }
                self.errorView.hidden = NO;
                return;
            }
            [self refreshUIWithItem:retItem];
        }];
    }else {
        [self.questionnaireRequest stopRequest];
        self.questionnaireRequest = [[GetQuestionnaireRequest alloc]init];
        self.questionnaireRequest.stepId = self.stepId;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.questionnaireRequest startRequestWithRetClass:[QuestionRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            self.errorView.hidden = YES;
            if (error) {
                if ([self isNetworkReachable]) {
                    [self.view nyx_showToast:error.localizedDescription];
                    return;
                }
                self.errorView.hidden = NO;
                return;
            }
            [self refreshUIWithItem:retItem];
        }];
    }
}

- (void)refreshUIWithItem:(QuestionRequestItem *)item {
    self.requestItem = item;
    [self.tableView reloadData];
    NSString *title = item.data.questionGroup.title;
    NSString *desc = item.data.questionGroup.desc;
    CGFloat height = [QuestionnaireHeaderView heightForTitle:title desc:desc];
    QuestionnaireHeaderView *headerView = [[QuestionnaireHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    headerView.title = title;
    headerView.desc = desc;
    self.tableView.tableHeaderView = headerView;
    
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"e2e2e2"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"a6abad"]] forState:UIControlStateNormal];
    if (!item.data.isAnswer.boolValue) {
        self.submitButton.hidden = NO;
    }else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [self.tableView registerClass:[ChooseQuestionCell class] forCellReuseIdentifier:@"ChooseQuestionCell"];
    [self.tableView registerClass:[FillQuestionCell class] forCellReuseIdentifier:@"FillQuestionCell"];
    
    self.submitButton = [[UIButton alloc]init];
    [self.submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"e2e2e2"] forState:UIControlStateDisabled];
    [self.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"a6abad"]] forState:UIControlStateDisabled];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(49);
    }];
    self.submitButton.hidden = YES;
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestPaperInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            CGFloat bottom = MAX([UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 49);
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
        }];
    }];
}

- (void)submitAction {
    if (![self allAnswered]) {
        [self.view nyx_showToast:@"请您填写完整"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交后内容不可修改，是否继续提交？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goSubmit];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:submit];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)goSubmit {
    NSString *answer = [self.requestItem.data.questionGroup answerString];
    if (self.interactType == InteractType_Vote) {
        [self.saveVoteRequest stopRequest];
        self.saveVoteRequest = [[SaveUserVoteRequest alloc]init];
        self.saveVoteRequest.stepId = self.stepId;
        self.saveVoteRequest.answers = answer;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.saveVoteRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self dealWithError:error];
                return;
            }
            [self.view.window nyx_showToast:@"提交成功"];
            BLOCK_EXEC(self.completeBlock);
            [self goVoteResult];
        }];
    }else if (self.interactType == InteractType_Evaluate) {
        [self.saveEvaluateRequest stopRequest];
        self.saveEvaluateRequest = [[SaveUserEvaluateRequest alloc]init];
        self.saveEvaluateRequest.stepId = self.stepId;
        self.saveEvaluateRequest.answers = answer;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.saveEvaluateRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self dealWithError:error];
                return;
            }
            [self.view.window nyx_showToast:@"提交成功"];
            BLOCK_EXEC(self.completeBlock);
            [self goEvaluateResult];
        }];
    }else {
        [self.saveQuestionnaireRequest stopRequest];
        self.saveQuestionnaireRequest = [[SaveUserQuestionnaireRequest alloc]init];
        self.saveQuestionnaireRequest.stepId = self.stepId;
        self.saveQuestionnaireRequest.answers = answer;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.saveQuestionnaireRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self dealWithError:error];
                return;
            }
            [self.view.window nyx_showToast:@"提交成功"];
            BLOCK_EXEC(self.completeBlock);
            [self goQuestionnaireResult];
        }];
    }
}

- (void)dealWithError:(NSError *)error {
    //    if ([self isNetworkReachable]) {
    //        [self.view nyx_showToast:@"你的输入内容中可能存在表情，请修改后再次提交!"];
    //    }else
    //    {
    [self.view nyx_showToast:error.localizedDescription];
    //    }
}

- (void)goVoteResult {
    QuestionnaireResultViewController *vc = [[QuestionnaireResultViewController alloc]initWithStepId:self.stepId];
    vc.name = self.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goQuestionnaireResult {
    QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:self.stepId interactType:self.interactType];
    vc.name = self.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goEvaluateResult {
    QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:self.stepId interactType:self.interactType];
    vc.name = self.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshSubmitButton {
    BOOL allAnswered = [self allAnswered];
    if (allAnswered) {
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateNormal];
    }else {
        [self.submitButton setTitleColor:[UIColor colorWithHexString:@"e2e2e2"] forState:UIControlStateNormal];
        [self.submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"a6abad"]] forState:UIControlStateNormal];
    }
}

- (BOOL)allAnswered {
    BOOL allAnswered = YES;
    for (QuestionRequestItem_question *question in self.requestItem.data.questionGroup.questions) {
        if (![question hasAnswer]) {
            allAnswered = NO;
            break;
        }
    }
    return allAnswered;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requestItem.data.questionGroup.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionRequestItem_question *question = self.requestItem.data.questionGroup.questions[indexPath.row];
    QuestionType type = [FSDataMappingTable QuestionTypeWithKey:question.questionType];
    if (type==QuestionType_SingleChoose || type==QuestionType_MultiChoose) {
        ChooseQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQuestionCell"];
        cell.index = indexPath.row+1;
        if (self.requestItem.data.isAnswer.boolValue) {
            cell.userInteractionEnabled = NO;
            cell.editable = NO;
        }
        cell.item = question;
        cell.bottomLineHidden = indexPath.row==self.requestItem.data.questionGroup.questions.count;
        WEAK_SELF
        [cell setAnswerChangeBlock:^{
            STRONG_SELF
            [self refreshSubmitButton];
        }];
        return cell;
    }
    if (type == QuestionType_Fill) {
        FillQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FillQuestionCell"];
        cell.index = indexPath.row+1;
        cell.item = question;
        cell.bottomLineHidden = indexPath.row==self.requestItem.data.questionGroup.questions.count;
        WEAK_SELF
        [cell setTextChangeBlock:^(NSString *text){
            STRONG_SELF
            [self refreshSubmitButton];
        }];
        [cell setEndEdittingBlock:^{
            STRONG_SELF
//            [self.tableView reloadData];
        }];
        [cell setBeginEdittingBlock:^{
            STRONG_SELF
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }];
        if (self.requestItem.data.isAnswer.boolValue) {
            cell.userInteractionEnabled = NO;
        }
        return cell;
    }
    return nil;
}

@end
