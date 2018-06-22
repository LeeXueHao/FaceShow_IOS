//
//  TaskNameCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskNameCell.h"
#import "GetUserTaskProgressRequest.h"

@interface TaskNameCell()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIView *lineView;
@end

@implementation TaskNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
//        [self setupMock];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - setupUI
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont boldSystemFontOfSize:14];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setupMock {
    self.nameLabel.text = @"作业总数";
    self.progressLabel.text = @"2/20";
}

- (void)setTask:(GetUserTaskProgressRequestItem_interactType *)task {
    task = task;
    self.nameLabel.text = task.interactTypeName;
    self.progressLabel.text = [NSString stringWithFormat:@"%@/%@",task.finishNum,task.taskNum];
}
@end
