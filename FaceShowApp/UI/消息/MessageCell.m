//
//  MessageCell.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MessageCell.h"
#import "GetNoticeListRequest.h"

@interface MessageCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *bedgeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.bedgeImageView = [[UIView alloc] init];
    self.bedgeImageView.clipsToBounds = YES;
    self.bedgeImageView.layer.cornerRadius = 3.5;
    self.bedgeImageView.backgroundColor = [UIColor redColor];
    [self.avatarImageView addSubview:self.bedgeImageView];
    [self.bedgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(15);
        make.centerY.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_top);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setNotice:(GetNoticeListRequestItem_Notice *)notice {
    _notice = notice;
    self.titleLabel.text = notice.title;
    self.timeLabel.text = notice.createTime;
    self.bedgeImageView.hidden = notice.viewed;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:notice.attachUrl] placeholderImage:[UIImage imageNamed:@""]];
}

@end
