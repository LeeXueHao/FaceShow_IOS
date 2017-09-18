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
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation QuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = headerView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
    [self.submitButton addTarget:self action:@selector(submitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
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
    
}

- (void)refreshSubmitButton {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<5) {
        ChooseQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQuestionCell"];
        cell.stem = @"请选择下面这个题";
        cell.index = indexPath.row+1;
        cell.optionArray = @[@"aaaaaaaaaaaaa111",
                             @"bbbbbdbfoifoegnoegnognowengoewngowenogwenogewnognoewgnowengiowegoweng222",
                             @"方便发你哦 供你热工农了333",
                             @"费二狗我个人弄内购gingNo工农人个人饿哦工日 个还给你N割肉给根荣格尼尔 盖聂弄个人 工农而个侬玩偶尔发我444"];
        cell.bottomLineHidden = indexPath.row==9;
        WEAK_SELF
        [cell setAnswerChangeBlock:^{
            STRONG_SELF
            [self refreshSubmitButton];
        }];
        return cell;
    }else {
        FillQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FillQuestionCell"];
        cell.stem = @"请谈谈你对这个问题的看法请谈谈你对这个问题的看法请谈谈你对这个问题的看法";
        cell.index = indexPath.row+1;
        cell.comment = @"";
        cell.bottomLineHidden = indexPath.row==9;
        WEAK_SELF
        [cell setTextChangeBlock:^(NSString *text){
            STRONG_SELF
            [self refreshSubmitButton];
        }];
        [cell setEndEdittingBlock:^{
            STRONG_SELF
            [self.tableView reloadData];
        }];
        return cell;
    }
}

@end
