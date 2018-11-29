//
//  NBResourceListCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBResourceListCell.h"
#import "ResourceTypeMapping.h"

@interface NBResourceListCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation NBResourceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.contentView.backgroundColor = [UIColor whiteColor];
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithString:@"272727"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.iconImageView);
    }];

    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor colorWithString:@"999999"];
    self.detailLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.iconImageView);
    }];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTagList:(GetResourceListRequestItem_tagList *)tagList{
    _tagList = tagList;
    self.titleLabel.text = tagList.name;
    self.iconImageView.image = [UIImage imageNamed:@"folder"];
    self.detailLabel.text = [NSString stringWithFormat:@"文件数：%@",tagList.resNum];
}

- (void)setResList:(GetResourceListRequestItem_resList *)resList{
    _resList = resList;
    self.iconImageView.image = [UIImage imageNamed:resList.type.integerValue ? @"html" : [ResourceTypeMapping resourceTypeWithString:resList.suffix]];
    self.titleLabel.text = resList.resName;
    self.detailLabel.text = [resList.createTime omitSecondOfFullDateString];
}

@end
