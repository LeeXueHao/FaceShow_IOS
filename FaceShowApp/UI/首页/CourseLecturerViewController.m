//
//  CourseLecturerViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseLecturerViewController.h"
#import "CourseCatalogCell.h"
#import "EmptyView.h"
#import "ProfessorDetailViewController.h"

@interface CourseLecturerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation CourseLecturerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLecturerInfos:(NSArray<GetCourseRequestItem_LecturerInfo,Optional> *)lecturerInfos {
    _lecturerInfos = lecturerInfos;
    [self.tableView reloadData];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 59;
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

    self.emptyView.hidden = !isEmpty(self.lecturerInfos);
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lecturerInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogCell"];
    GetCourseRequestItem_LecturerInfo *info = self.lecturerInfos[indexPath.row];
    cell.title = info.lecturerName;
    cell.iconName = @"讲师";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetCourseRequestItem_LecturerInfo *info = self.lecturerInfos[indexPath.row];
    ProfessorDetailViewController *professorDetailVC = [[ProfessorDetailViewController alloc] init];
    professorDetailVC.lecturerInfo = info;
    [self.navigationController pushViewController:professorDetailVC animated:NO];
}

@end
