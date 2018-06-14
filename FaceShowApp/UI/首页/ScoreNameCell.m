//
//  ScoreNameCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreNameCell.h"
#import "GetUserClazsScoreRequest.h"

@interface ScoreNameCell()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *scoreLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UIView *lineView;
@end

@implementation ScoreNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupMock];
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
        make.centerY.mas_equalTo(0).offset(-10);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(6);
    }];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.contentView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
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
    self.descLabel.text = @"每个2分";
    self.scoreLabel.text = @"2分";
}

- (void)setItem:(GetUserClazsScoreRequestItem_userScoreItem *)item {
    _item = item;
    self.nameLabel.text = item.scoreName;
    self.descLabel.text = [NSString stringWithFormat:@"每个%@分",item.scoreDefine];
    self.scoreLabel.text = item.scoreValue;
}
@end
