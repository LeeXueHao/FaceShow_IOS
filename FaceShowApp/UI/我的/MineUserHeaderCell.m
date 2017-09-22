//
//  MineUserHeaderCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineUserHeaderCell.h"
@interface MineUserHeaderCell ()
@property (nonatomic, strong) UIImageView *userHeaderImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@end

@implementation MineUserHeaderCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kYXUploadUserPicSuccessNotification" object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            [self reload];
        }];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    //    UIView *selectedBgView = [[UIView alloc]init];
    //    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    //    self.selectedBackgroundView = selectedBgView;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.userHeaderImageView = [[UIImageView alloc] init];
    self.userHeaderImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    
    self.userHeaderImageView.clipsToBounds = YES;
    self.userHeaderImageView.layer.cornerRadius = 6.0f;
    [self.contentView addSubview:self.userHeaderImageView];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    
    self.nextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.nextImageView];
    
}
- (void)setupLayout {
    [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(55.0f, 55.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImageView.mas_right).offset(14.0f);
        make.centerY.equalTo(self.userHeaderImageView.mas_centerY);
        make.right.lessThanOrEqualTo(self.nextImageView.mas_left).offset(-15.0f);
    }];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5.0f);
        make.centerY.equalTo(self.userHeaderImageView.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮点击态"];
    }
    else{
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }
}
- (void)reload {
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"我个人头像默认图"]];
    self.nameLabel.text = [UserManager sharedInstance].userModel.realName?:@"暂无";
    
}
@end
