//
//  AreaSubjectViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AreaSubjectViewController.h"
#import "AreaSubjectCell.h"
#import "UpdateUserInfoRequest.h"
@implementation AreaSubjectItem
@end
@interface AreaSubjectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UpdateUserInfoRequest *request;
@end

@implementation AreaSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDefaultArea];
}
- (void)setDefaultArea {
    UIBarButtonItem *item =  self.navigationItem.rightBarButtonItems[1];
    item.enabled = NO;
    NSString *chooseId = @"";
    if (self.status == AreaSubject_Province) {
        chooseId = self.provinceItem.chooseId;
    }else if (self.status == AreaSubject_city) {
        chooseId = self.cityItem.chooseId;
    }else {
        chooseId = self.countryItem.chooseId;
    }
    [self.dataArray enumerateObjectsUsingBlock:^(Area *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:chooseId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setSelected:YES animated:YES];
            item.enabled = YES;
            *stop = YES;
        }
    }];
}
- (void)updateUserInfo {
    [self.request stopRequest];
    self.request = [[UpdateUserInfoRequest alloc]init];
    self.request.province = self.provinceItem.chooseId;
    self.request.city = self.cityItem.chooseId;
    self.request.country = self.countryItem.chooseId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].userModel.aui.province = self.provinceItem.chooseId;
        [UserManager sharedInstance].userModel.aui.provinceName = self.provinceItem.chooseName;
        [UserManager sharedInstance].userModel.aui.city = self.cityItem.chooseId;
        [UserManager sharedInstance].userModel.aui.cityName = self.cityItem.chooseName;
        [UserManager sharedInstance].userModel.aui.country = self.countryItem.chooseId;
        [UserManager sharedInstance].userModel.aui.countryName = self.countryItem.chooseName;
        [[UserManager sharedInstance] saveData];
        BLOCK_EXEC(self.completeBlock);
        NSInteger index = self.navigationController.viewControllers.count-4;
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
    }];
}

#pragma mark - setupNavigation
- (void)setupNavigation {
    if (self.status == AreaSubject_Province) {
        self.navigationItem.title = @"请选择省";
        WEAK_SELF
        [self nyx_setupRightWithTitle:@"下一步" action:^{
            STRONG_SELF
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (isEmpty(indexPath)) {
                [self.view nyx_showToast:@"请选择省"];
                return;
            }
            AreaSubjectViewController *vc = [[AreaSubjectViewController alloc] init];
            Area *are = self.dataArray[indexPath.row];
            vc.dataArray = are.sub;
            vc.provinceItem = self.provinceItem;
            vc.cityItem = self.cityItem;
            vc.countryItem = self.countryItem;
            vc.status = AreaSubject_city;
            vc.completeBlock = ^{
                STRONG_SELF
                BLOCK_EXEC(self.completeBlock);
            };
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }else if (self.status == AreaSubject_city) {
        self.navigationItem.title = self.provinceItem.chooseName;
        WEAK_SELF
        [self nyx_setupRightWithTitle:@"下一步" action:^{
            STRONG_SELF
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (isEmpty(indexPath)) {
                [self.view nyx_showToast:@"请选择市"];
                return;
            }
            AreaSubjectViewController *vc = [[AreaSubjectViewController alloc] init];
            Area *are = self.dataArray[indexPath.row];
            vc.dataArray = are.sub;
            vc.provinceItem = self.provinceItem;
            vc.cityItem = self.cityItem;
            vc.countryItem = self.countryItem;
            vc.status = AreaSubject_country;
            vc.completeBlock = ^{
                STRONG_SELF
                BLOCK_EXEC(self.completeBlock);
            };
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else {
        self.navigationItem.title = self.cityItem.chooseName;
        WEAK_SELF
        [self nyx_setupRightWithTitle:@"确定" action:^{
            STRONG_SELF
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (isEmpty(indexPath)) {
                [self.view nyx_showToast:@"请选择区"];
                return;
            }
            [self updateUserInfo];
        }];
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 45;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[AreaSubjectCell class] forCellReuseIdentifier:@"AreaSubjectCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AreaSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaSubjectCell"];
    Area *data = self.dataArray[indexPath.row];
    cell.textLabel.text = data.name;
    cell.isLastRow = indexPath.row == self.dataArray.count-1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Area *data = self.dataArray[indexPath.row];
    AreaSubjectItem *item = [[AreaSubjectItem alloc] init];
    item.chooseId = data.areaID;
    item.chooseName = data.name;
    if (self.status == AreaSubject_Province) {
        self.provinceItem = item;
    }else if (self.status == AreaSubject_city) {
        self.cityItem = item;
    }else {
        self.countryItem = item;
    }
    UIBarButtonItem *barItem =  self.navigationItem.rightBarButtonItems[1];
    barItem.enabled = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    return header;
}

@end
