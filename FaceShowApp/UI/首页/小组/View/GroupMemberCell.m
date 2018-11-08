//
//  GroupMemberCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GroupMemberCell.h"

@interface GroupMemberCell()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation GroupMemberCell

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
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
    }];

    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.schoolLabel];
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.nameLabel);
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

- (void)setStudents:(GroupDetailByStudentRequest_Item_students *)students{
    _students = students;

    WEAK_SELF
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:students.avatar] placeholderImage:[UIImage imageNamed:@"班级圈小默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",students.realName];
    self.schoolLabel.text = [NSString stringWithFormat:@"%@",students.school];
}

- (void)setIsLastRow:(BOOL)isLastRow {
    _isLastRow = isLastRow;
    self.lineView.hidden = isLastRow;
}

@end
