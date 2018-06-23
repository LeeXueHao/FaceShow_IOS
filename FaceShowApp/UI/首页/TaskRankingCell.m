//
//  TaskRankingCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskRankingCell.h"
#import "GetUserTasksProgressRankRequest.h"

@implementation TaskRankingCellItem
@end

@interface TaskRankingCell ()
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TaskRankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.rankLabel = [[UILabel alloc] init];
    self.rankLabel.font = [UIFont systemFontOfSize:14];
    self.rankLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5;
    self.avatarImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rankLabel.mas_right);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont boldSystemFontOfSize:16];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

//- (void)setData:(ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo *)data {
//    _data = data;
//    self.avatarImageView.contentMode = UIViewContentModeCenter;
//
//    WEAK_SELF
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.memberInfo.avatar] placeholderImage:[UIImage imageNamed:@"班级圈小默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        STRONG_SELF
//        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
//    }];
//    self.nameLabel.text = data.memberInfo.memberName;
//    //    self.numberLabel.text = data.mobilePhone;
//}

- (void)setItem:(TaskRankingCellItem *)item {
    _item = item;
    GetUserTasksProgressRankRequestItem_element *element = item.element;
    self.rankLabel.text = [NSString stringWithFormat:@"%@",@(item.rank)];
    self.avatarImageView.contentMode = UIViewContentModeCenter;
    WEAK_SELF
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:element.avator] placeholderImage:[UIImage imageNamed:@"班级圈小默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    self.nameLabel.text = element.userName;
    CGFloat progress = [element.finishPercent floatValue] * 100;
    NSString *progressStr = [NSString stringWithFormat:@"%@",@(progress)];
    if ([progressStr containsString:@"."]) {
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%@",[progressStr floatValue],@"%"];
    }else {
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%@",[progressStr floatValue],@"%"];
    }
}

- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    if (isShowLine) {
        self.lineView.hidden = NO;
    }else {
        self.lineView.hidden = YES;
    }
}
@end
