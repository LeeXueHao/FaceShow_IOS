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
#import "ContactMemberContactsRequest.h"

@interface ContactsClassFilterView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
//@property(nonatomic, strong) UIButton *confirmButton;
@property(nonatomic, copy) ContactsClassFilterCompletedBlock block;
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
        //        make.left.top.right.mas_equalTo(0);
        //        make.bottom.mas_equalTo(-45.f);
    }];
    
    //    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    //    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    //    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    //    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    //    self.confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    //    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1a90d9"]] forState:UIControlStateHighlighted];
    //    [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:self.confirmButton];
    //    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.bottom.mas_equalTo(0);
    //        make.height.mas_equalTo(45.f);
    //    }];
}

//- (void)confirmAction {
//    BLOCK_EXEC(self.block,self.dataArray[self.selectedRow],self.selectedRow);
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsClassFilterCell *cell = [[ContactsClassFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ContactMemberContactsRequestItem_Data_Gcontacts_Groups *group = self.dataArray[indexPath.row];
    cell.title = group.groupName;
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
    BLOCK_EXEC(self.block,self.dataArray[self.selectedRow],self.selectedRow);
}

- (CGFloat)heightForContactsClassFilterView {
    return self.dataArray.count * 50;
}

- (void)setContactsClassFilterCompletedBlock:(ContactsClassFilterCompletedBlock)block {
    self.block = block;
}

- (void)reloadData {
    [self.tableView reloadData];
}
@end
