//
//  ContactsClassFilterView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsClassFilterView.h"
#import "ContactsClassFilterCell.h"
#import "UIImage+Color.h"
#import "ClassListRequest.h"

@interface ContactsClassFilterView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) ClazsListFilterCompletedBlock clazsBlock;
@end

@implementation ContactsClassFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectedRow = 0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedSectionHeaderHeight = 0.f;
    self.tableView.estimatedSectionFooterHeight = 0.f;
    [self.tableView registerClass:[ContactsClassFilterCell class] forCellReuseIdentifier:@"ContactsClassFilterCell"];
    [self addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clazsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsClassFilterCell *cell = [[ContactsClassFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ClassListRequestItem_clazsInfos *clazsInfo = self.clazsArray[indexPath.row];
    cell.title = clazsInfo.clazsName;
    if (self.selectedRow == indexPath.row) {
        cell.isChoosed = YES;
    }else {
        cell.isChoosed = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    BLOCK_EXEC(self.clazsBlock,self.clazsArray[self.selectedRow],self.selectedRow);
}

- (CGFloat)heightForContactsClassFilterView {
    return self.clazsArray.count * 50;
}


- (void)setClazsFilterCompleteBlock:(ClazsListFilterCompletedBlock)block{
    self.clazsBlock = block;
}

- (void)reloadData {
    [self.tableView reloadData];
}
@end
