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
#import "ClassMomentFooterView.h"
#import "PostMomentViewController.h"
#import "ClassMomentFloatingView.h"
@interface ClassMomentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ClassMomentTableHeaderView *headerView;
@property (nonatomic, strong) ClassMomentFloatingView *floatingView;
@end

@implementation ClassMomentViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
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
#pragma mark - set & get
- (ClassMomentFloatingView *)floatingView {
    if (_floatingView == nil) {
        _floatingView = [[ClassMomentFloatingView alloc] init];
    }
    return _floatingView;
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
    [self.tableView registerClass:[ClassMomentFooterView class] forHeaderFooterViewReuseIdentifier:@"ClassMomentFooterView"];
    self.headerView = [[ClassMomentTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157.0f)];
    self.tableView.tableHeaderView = self.headerView;
    WEAK_SELF
    [self nyx_setupRightWithImage:[UIImage imageNamed:@"消息动态icon点击态-正常态-拷贝"] action:^{
        STRONG_SELF
        PostMomentViewController *VC = [[PostMomentViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassMomentCell" forIndexPath:indexPath];
    [cell reloadName:@"高涛" withComment:@"大开间大家都;卡就是开机是伐啦好蓝非哈伦裤回复拉科技和水电费逻辑哈师大浪费" withLast:indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassMomentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClassMomentHeaderView"];
    headerView.testInteger = [self.dataArray[section] integerValue];
    WEAK_SELF
    headerView.classMomentLikeCommentBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.view];
        [self showFloatView:rect];
    };
    return headerView;
}
- (void)showFloatView:(CGRect)rect {
    [self.view addSubview:self.floatingView];
    self.floatingView.originRect = rect;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ClassMomentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClassMomentFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"ClassMomentHeaderView" configuration:^(ClassMomentHeaderView *headerView) {
        headerView.testInteger = [self.dataArray[section] integerValue];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"ClassMomentCell" configuration:^(ClassMomentCell *cell) {
        [cell reloadName:@"高涛" withComment:@"大开间大家都;卡就是开机" withLast:indexPath.row];
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.floatingView removeFromSuperview];
}
@end
