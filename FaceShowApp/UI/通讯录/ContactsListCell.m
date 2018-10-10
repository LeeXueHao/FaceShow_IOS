//
//  ContactsListCell.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ContactsListCell.h"

@interface ContactsListCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ContactsListCell

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
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5;
    self.avatarImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.numberLabel.mas_left).offset(-10);
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

- (void)setData:(GetUserInfoRequestItem_Data *)data {
    _data = data;
    self.avatarImageView.contentMode = UIViewContentModeCenter;

    WEAK_SELF
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"班级圈小默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    self.nameLabel.text = data.realName;
    self.numberLabel.text = data.mobilePhone;
}

- (void)setIsLastRow:(BOOL)isLastRow {
    _isLastRow = isLastRow;
    self.lineView.hidden = isLastRow;
}

@end
