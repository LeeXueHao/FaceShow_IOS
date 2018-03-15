//
//  CourseLectureCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseLectureCell.h"

@interface CourseLectureCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation CourseLectureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 5;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.2].CGColor;
    self.headImageView.layer.shadowRadius = 2;
    self.headImageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.headImageView.layer.shadowOpacity = 1;
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(self.headImageView.mas_centerY);
    }];
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.descLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_left);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-25);
    }];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
}

- (void)setData:(GetCourseRequestItem_LecturerInfo *)data {
    _data = data;
    self.nameLabel.text = data.lecturerName;
    WEAK_SELF
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data.lecturerAvatar] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        self.headImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *project = data.lecturerBriefing;
    NSAttributedString *projectAttributeStr = [[NSAttributedString alloc] initWithString:project attributes:dic];
    self.descLabel.attributedText = projectAttributeStr;
}

@end
