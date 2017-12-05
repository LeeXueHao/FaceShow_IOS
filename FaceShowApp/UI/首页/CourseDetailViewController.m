//
//  CourseDetailViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "ErrorView.h"
#import "CourseDetailHeaderView.h"
#import "CourseCatalogCell.h"
#import "CourseBriefViewController.h"
#import "ProfessorDetailViewController.h"
#import "GetCourseRequest.h"
#import "FSDataMappingTable.h"
#import "QuestionnaireViewController.h"
#import "QuestionnaireResultViewController.h"
#import "CourseCommentViewController.h"
#import "ResourceTypeMapping.h"
#import "GetResourceDetailRequest.h"
#import "ResourceDisplayViewController.h"

@interface CourseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CourseDetailHeaderView *headerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) GetCourseRequest *request;
@property (nonatomic, strong) GetResourceDetailRequest *detailRequest;
@property (nonatomic, strong) GetCourseRequestItem_Data *data;
@property (nonatomic, strong) NSMutableArray<NSArray *> *dataArray;
@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupCourseData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setupCourseData {
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request stopRequest];
    self.request = [[GetCourseRequest alloc] init];
    self.request.courseId = self.courseId;
    [self.request startRequestWithRetClass:[GetCourseRequestItem class] andCompleteBlock:^(GetCourseRequestItem *retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.data = retItem.data;
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:!isEmpty(self.data.course.lecturerInfos) ? self.data.course.lecturerInfos : [NSArray array]];
        [self.dataArray addObject:!isEmpty(self.data.course.attachmentInfos) ? self.data.course.attachmentInfos : [NSArray array]];
        [self.dataArray addObject:!isEmpty(self.data.interactSteps) ? self.data.interactSteps : [NSArray array]];
        self.tableView.hidden = NO;
        self.tableView.tableHeaderView = [self headerViewWithCourse:self.data.course];
        [self.tableView reloadData];
    }];
}

- (CourseDetailHeaderView *)headerViewWithCourse:(GetCourseRequestItem_Course *)course {
    CGFloat height = [CourseDetailHeaderView heightForCourse:course];
    CourseDetailHeaderView *headerView = [[CourseDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    headerView.course = course;
    WEAK_SELF
    headerView.viewAllBlock = ^{
        STRONG_SELF
        CourseBriefViewController *courseBriefVC = [[CourseBriefViewController alloc] init];
        courseBriefVC.courseBrief = course.briefing;
        [self.navigationController pushViewController:courseBriefVC animated:NO];
    };
    return headerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)requestResourceDetailWithResId:(NSString *)resId {
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.detailRequest stopRequest];
    self.detailRequest = [[GetResourceDetailRequest alloc] init];
    self.detailRequest.resId = resId;
    [self.detailRequest startRequestWithRetClass:[GetResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];;
            return;
        }
        GetResourceDetailRequestItem *item = (GetResourceDetailRequestItem *)retItem;
        BOOL isAttachment = item.data.type.integerValue == 0;
        ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc] init];
        vc.urlString = isAttachment ? item.data.ai.previewUrl : item.data.url;
        vc.name = item.data.resName;
        vc.needDownload = isAttachment;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.errorView = [[ErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self setupCourseData];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[CourseCatalogCell class] forCellReuseIdentifier:@"CourseCatalogCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.hidden = YES;

    UIView *backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    self.backView = backView;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回页面按钮正常态-"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回页面按钮点击态"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(self.view.mas_top).offset(42);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogCell"];
    if (indexPath.section == 0) {
        GetCourseRequestItem_LecturerInfo *info = self.dataArray[0][indexPath.row];
        cell.title = info.lecturerName;
        cell.iconName = @"讲师";
    } else if (indexPath.section == 1) {
        GetCourseRequestItem_AttachmentInfo *info = self.dataArray[1][indexPath.row];
        cell.title = info.resName;
        cell.iconName = [ResourceTypeMapping resourceTypeWithString:info.resType];
    } else if (indexPath.section == 2) {
        GetCourseRequestItem_InteractStep *info = self.dataArray[2][indexPath.row];
        cell.title = info.interactName;
        InteractType type = [FSDataMappingTable InteractTypeWithKey:info.interactType];
        if (type == InteractType_Vote) {
            cell.iconName = @"投票icon";
        } else if (type == InteractType_Questionare) {
            cell.iconName = @"问卷";
        } else if (type == InteractType_Comment) {
            cell.iconName = @"评论icon";
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        GetCourseRequestItem_LecturerInfo *info = self.dataArray[0][indexPath.row];
        ProfessorDetailViewController *professorDetailVC = [[ProfessorDetailViewController alloc] init];
        professorDetailVC.lecturerInfo = info;
        [self.navigationController pushViewController:professorDetailVC animated:NO];
    } else if (indexPath.section == 1) {
        GetCourseRequestItem_AttachmentInfo *info = self.dataArray[1][indexPath.row];
        [self requestResourceDetailWithResId:info.resId];
    } else if (indexPath.section == 2) {
        GetCourseRequestItem_InteractStep *info = self.dataArray[2][indexPath.row];
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
        }else if (type == InteractType_Comment) {
            CourseCommentViewController *vc = [[CourseCommentViewController alloc]initWithStepId:info.stepId];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = MAX(scrollView.contentOffset.y, 0);
    offsetY = MIN(offsetY, 135-64);
    self.backView.backgroundColor = [[UIColor colorWithHexString:@"1da1f2"]colorWithAlphaComponent:offsetY/(135-64)];
}

@end
