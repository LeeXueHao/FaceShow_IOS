//
//  CourseTaskViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTaskViewController.h"
#import "CourseCatalogCell.h"
#import "FSDataMappingTable.h"
#import "QuestionnaireViewController.h"
#import "CourseCommentViewController.h"
#import "SignInDetailViewController.h"
#import "EmptyView.h"
#import "QuestionnaireResultViewController.h"
#import "GetHomeworkRequest.h"
#import "FinishedHomeworkViewController.h"
#import "HomeworkRequirementViewController.h"
@interface CourseTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@property(nonatomic, strong) GetHomeworkRequest *getHomeworkRequest;

@end

@implementation CourseTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController.navigationBarHidden) {
        return;
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)setInteractSteps:(NSArray<GetCourseRequestItem_InteractStep,Optional> *)interactSteps {
    _interactSteps = interactSteps;
    [self.tableView reloadData];
    if (interactSteps.count == 0) {
        self.emptyView.hidden = NO;
    }
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseCatalogCell class] forCellReuseIdentifier:@"CourseCatalogCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interactSteps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogCell"];
    GetCourseRequestItem_InteractStep *info = self.interactSteps[indexPath.row];
    cell.title = info.interactName;
    InteractType type = [FSDataMappingTable InteractTypeWithKey:info.interactType];
    if (type == InteractType_Vote) {
        cell.iconName = @"投票";
    } else if (type == InteractType_Questionare) {
        cell.iconName = @"问卷";
    } else if (type == InteractType_Comment) {
        cell.iconName = @"讨论";
    } else if (type == InteractType_Homework) {
        cell.iconName = @"作业";
    }else if (type == InteractType_Evaluate) {
        cell.iconName = @"评价";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetCourseRequestItem_InteractStep *info = self.interactSteps[indexPath.row];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:info.interactType];
    if (type == InteractType_Vote) {
        if (info.stepFinished.boolValue) {
            QuestionnaireResultViewController *vc = [[QuestionnaireResultViewController alloc]initWithStepId:info.stepId];
            vc.name = info.interactName;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:info.stepId interactType:type];
            vc.name = info.interactName;
            WEAK_SELF
            [vc setCompleteBlock:^{
                STRONG_SELF
                info.stepFinished = @"1";
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (type == InteractType_Questionare) {
        QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:info.stepId interactType:type];
        vc.name = info.interactName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_Evaluate) {
        QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:info.stepId interactType:type];
        vc.name = info.interactName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_Comment) {
        CourseCommentViewController *vc = [[CourseCommentViewController alloc]initWithStepId:info.stepId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_Homework) {
        [self.getHomeworkRequest stopRequest];
        self.getHomeworkRequest = [[GetHomeworkRequest alloc]init];
        self.getHomeworkRequest.stepId = info.stepId;
        WEAK_SELF
        [self.view nyx_startLoading];
        [self.getHomeworkRequest startRequestWithRetClass:[GetHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            GetHomeworkRequestItem *item = (GetHomeworkRequestItem *)retItem;
            if ([item.data.userHomework.finishStatus isEqualToString:@"1"]) {
                FinishedHomeworkViewController *vc = [[FinishedHomeworkViewController alloc]init];
                vc.userHomework = item.data.userHomework;
                vc.homework = item.data.homework;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                HomeworkRequirementViewController *vc = [[HomeworkRequirementViewController alloc]init];
                vc.homework = item.data.homework;
                vc.userHomework = item.data.userHomework;
                vc.isFinished = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

@end
