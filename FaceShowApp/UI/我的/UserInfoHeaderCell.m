//
//  UserInfoHeaderCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoHeaderCell.h"
@interface UserInfoHeaderCell ()
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation UserInfoHeaderCell
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
    self.userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userHeaderButton.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.userHeaderButton.clipsToBounds = YES;
    self.userHeaderButton.userInteractionEnabled = NO;
    self.userHeaderButton.layer.cornerRadius = 6.0f;
    [self.contentView addSubview:self.userHeaderButton];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"头像";
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    
    self.nextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.nextImageView];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    
}
- (void)setupLayout {
    [self.userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextImageView.mas_left).offset(-5.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(55.0f, 55.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.userHeaderButton.mas_centerY);
    }];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5.0f);
        make.centerY.equalTo(self.userHeaderButton.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_offset(1.0f);
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
    [self.userHeaderButton sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"我个人头像默认图"]];
}

@end
