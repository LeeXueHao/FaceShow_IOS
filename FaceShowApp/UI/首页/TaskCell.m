//
//  TaskCell.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TaskCell.h"
#import "FSDataMappingTable.h"

@interface TaskCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *draftButton;
@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.draftButton = [[UIButton alloc]init];
    [self.draftButton setBackgroundImage:[UIImage imageNamed:@"草稿"] forState:UIControlStateNormal];
    self.draftButton.userInteractionEnabled = NO;
    [self.contentView addSubview:self.draftButton];
    [self.draftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.statusLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.draftButton.mas_top).offset(-2);
        make.right.mas_lessThanOrEqualTo(self.draftButton.mas_left).offset(-5);
    }];
    
    self.sourceLabel = [[UILabel alloc] init];
    self.sourceLabel.font = [UIFont systemFontOfSize:11];
    self.sourceLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.mas_equalTo(self.draftButton.mas_bottom).offset(5);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTask:(GetAllTasksRequestItem_task *)task {
    _task = task;
    self.titleLabel.text = task.interactName;
    if (task.courseName.length <= 0) {
        task.courseName = @"班级任务";
    }
    self.sourceLabel.text = [NSString stringWithFormat:@"所属课程:%@",task.courseName];
    if (task.stepFinished.boolValue) {
        self.statusLabel.text = @"已完成";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }else {
        self.statusLabel.text = @"未完成";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"f56f5d"];
    }

    InteractType type = [FSDataMappingTable InteractTypeWithKey:task.interactType];
    if (type == InteractType_Vote) {
        self.iconImageView.image = [UIImage imageNamed:@"投票"];
    } else if (type == InteractType_Questionare) {
        self.iconImageView.image = [UIImage imageNamed:@"问卷"];
    } else if (type == InteractType_Comment) {
        self.iconImageView.image = [UIImage imageNamed:@"讨论"];
    } else if (type == InteractType_SignIn) {
        self.iconImageView.image = [UIImage imageNamed:@"签到icon"];
    } else if (type == InteractType_Homework) {
        self.iconImageView.image = [UIImage imageNamed:@"作业"];
    }else if (type == InteractType_Evaluate) {
        self.iconImageView.image = [UIImage imageNamed:@"评价"];
    }
    
    if (type == InteractType_Homework && [task.draft isEqualToString:@"1"]) {
        [self.draftButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
        }];
    }else {
        [self.draftButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

@end
