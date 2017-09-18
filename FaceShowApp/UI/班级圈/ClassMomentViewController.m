//
//  ClassMomentViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentViewController.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "ClassMomentHeaderView.h"
#import "ClassMomentCell.h"
#import "ClassMomentTableHeaderView.h"
#import "FSDefaultHeaderFooterView.h"
@interface ClassMomentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ClassMomentTableHeaderView *headerView;
@end

@implementation ClassMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级圈";
    [self.dataArray addObject:@"1"];
    [self.dataArray addObject:@"0"];
    [self.dataArray addObject:@"2"];
    [self.dataArray addObject:@"3"];
    [self.dataArray addObject:@"4"];
    [self.dataArray addObject:@"1"];
//    [self.dataArray addObject:@"9"];
//    [self.dataArray addObject:@"2"];
//    [self.dataArray addObject:@"4"];
//    [self.dataArray addObject:@"6"];
//    [self.dataArray addObject:@"8"];
//    [self.dataArray addObject:@"1"];
//    [self.dataArray addObject:@"1"];
//    [self.dataArray addObject:@"3"];
//    [self.dataArray addObject:@"5"];
//    [self.dataArray addObject:@"7"];
//    [self.dataArray addObject:@"9"];
//    [self.dataArray addObject:@"2"];
//    [self.dataArray addObject:@"4"];
//    [self.dataArray addObject:@"6"];
//    [self.dataArray addObject:@"8"];
//    [self.dataArray addObject:@"1"];
    [self setupUI];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    [self.view nyx_stopLoading];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ClassMomentHeaderView class] forHeaderFooterViewReuseIdentifier:@"ClassMomentHeaderView"];
    [self.tableView registerClass:[ClassMomentCell class] forCellReuseIdentifier:@"ClassMomentCell"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    self.headerView = [[ClassMomentTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157.0f)];
    self.tableView.tableHeaderView = self.headerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassMomentCell" forIndexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassMomentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClassMomentHeaderView"];
    headerView.testInteger = [self.dataArray[section] integerValue];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    footerView.contentView.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"ClassMomentHeaderView" configuration:^(ClassMomentHeaderView *headerView) {
        headerView.testInteger = [self.dataArray[section] integerValue];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"ClassMomentCell" configuration:^(ClassMomentCell *cell) {
        
    }];
}
@end
