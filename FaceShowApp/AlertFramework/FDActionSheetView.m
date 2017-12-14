//
//  FDActionSheetView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FDActionSheetView.h"
#import "FDActionSheetCell.h"
#import "FDActionSheetHeaderView.h"
#import "FDActionSheetFooterView.h"
@interface FDActionSheetView ()<UITableViewDelegate, UITableViewDataSource>
@end
@implementation FDActionSheetView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupUI];
    }
    return self;
}
- (void)setTitleArray:(NSArray<__kindof NSDictionary *> *)titleArray {
    _titleArray = titleArray;
    [self reloadData];
}
- (void)setTipsString:(NSString *)tipsString {
    _tipsString = tipsString;
    [self reloadData];
}
#pragma mark - setupUI
- (void)setupUI {
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.separatorColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = 50.0f;
    self.scrollEnabled = NO;
    self.sectionFooterHeight = 55.0f;
    [self registerClass:[FDActionSheetCell class] forCellReuseIdentifier:@"FDActionSheetCell"];
    [self registerClass:[FDActionSheetHeaderView class] forHeaderFooterViewReuseIdentifier:@"FDActionSheetHeaderView"];
    [self registerClass:[FDActionSheetFooterView class] forHeaderFooterViewReuseIdentifier:@"FDActionSheetFooterView"];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDActionSheetCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row][@"title"];
    cell.lineView.hidden = NO;
    return cell;
}
#pragma mark - UITableViewDataScore
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return isEmpty(self.tipsString) ? 0.0000001f : 50.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FDActionSheetHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FDActionSheetHeaderView"];
    headerView.title = self.tipsString;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 55.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FDActionSheetFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FDActionSheetFooterView"];
    WEAK_SELF
    footerView.actionSheetCancleBlock = ^{
        STRONG_SELF
        BLOCK_EXEC(self.actionSheetBlock,0);
    };
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BLOCK_EXEC(self.actionSheetBlock,indexPath.row + 1);
}
@end
