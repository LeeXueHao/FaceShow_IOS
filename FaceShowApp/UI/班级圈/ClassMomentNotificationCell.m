//
//  ClassMomentNotificationCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentNotificationCell.h"
@interface ClassMomentNotificationCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *commetnLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation ClassMomentNotificationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setMessage:(ClassMomentUserMomentMsgItem_Data_Msg *)message {
    _message = message;
    self.nameLabel.text = _message.userName;
    self.timeLabel.text = _message.createTime;
    self.likeImageView.hidden = _message.msgType.integerValue != 1;
    self.contentLabel.hidden = _message.msgType.integerValue == 1;
    self.contentLabel.text = _message.comment;
    if (_message.momentSimple.image.length > 0) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_message.momentSimple.image] placeholderImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
        self.photoImageView.hidden = NO;
        self.commetnLabel.hidden = YES;
    }else {
        self.commetnLabel.text = _message.momentSimple.content;
        self.photoImageView.hidden = YES;
        self.commetnLabel.hidden = NO;
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.contentLabel];
    
    self.likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"赞点后的小标签"]];
    [self.contentView addSubview:self.likeImageView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.photoImageView = [[UIImageView alloc] init];
    self.photoImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.contentView addSubview:self.photoImageView];
    
    self.commetnLabel = [[UILabel alloc] init];
    self.commetnLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.commetnLabel.font = [UIFont systemFontOfSize:14.0f];
    self.commetnLabel.textAlignment = NSTextAlignmentRight;
    self.commetnLabel.numberOfLines = 4;
    [self.contentView addSubview:self.commetnLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(12.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.photoImageView.mas_left).offset(-10.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4.0f);
    }];
    
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6.0f);
        make.size.mas_offset(CGSizeMake(12.0f, 12.0f));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-13.0f);
    }];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.size.mas_offset(CGSizeMake(60.0f, 60.0f));
    }];
    
    [self.commetnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14.0f);
        make.width.mas_offset(60.f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(2.0f);
    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
