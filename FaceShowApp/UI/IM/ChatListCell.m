//
//  ChatListCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ChatListCell.h"
#import "IMTopic.h"
#import "IMManager.h"
#import "IMTimeHandleManger.h"
#import "IMUserInterface.h"

@interface ChatListCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ChatListCell

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
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.tipImageView = [[UIImageView alloc] init];
    self.tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tipImageView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    self.tipImageView.clipsToBounds = YES;
    self.tipImageView.layer.cornerRadius = 4.5;
    self.tipImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarImageView.mas_right).offset(3.5);
        make.top.equalTo(self.avatarImageView.mas_top).offset(-3.5);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.mas_equalTo(14);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10.f);
        make.height.mas_equalTo(16.f);
    }];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont boldSystemFontOfSize:13];
    self.messageLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.mas_equalTo(-15.f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
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

- (void)setTopic:(IMTopic *)topic {
    _topic = topic;
    if (topic.type == TopicType_Group) {
        self.avatarImageView.image = [UIImage imageNamed:@"群聊-背景"];
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",@"班级群聊",topic.group];
        if (topic.latestMessage) {
            if (topic.latestMessage.type == MessageType_Image) {
                self.messageLabel.text = [NSString stringWithFormat:@"%@:%@",topic.latestMessage.sender.name,@"[图片]"];
            }else {
                self.messageLabel.text = [NSString stringWithFormat:@"%@:%@",topic.latestMessage.sender.name,topic.latestMessage.text];
            }
        }
    }else {
        WEAK_SELF
        [topic.members enumerateObjectsUsingBlock:^(IMMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STRONG_SELF
            if ([[IMManager sharedInstance] currentMember].memberID != obj.memberID) {
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:obj.avatar] placeholderImage:[UIImage imageNamed:@"我个人头像默认图"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    STRONG_SELF
                    self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
                }];
//                if (topic.group) {
//                    self.nameLabel.text =[NSString stringWithFormat:@"%@(%@)",obj.name,topic.group];
//                }else {
//                    self.nameLabel.text =[NSString stringWithFormat:@"%@",obj.name];
//                }
                //私聊暂不显示班级来源
                self.nameLabel.text =[NSString stringWithFormat:@"%@",obj.name];
                *stop = YES;
            }
        }];
        if (topic.latestMessage.type == MessageType_Image) {
            self.messageLabel.text = @"[图片]";
        }else {
            self.messageLabel.text = topic.latestMessage.text;
        }
    }
    if (topic.latestMessage && topic.latestMessage.sendTime > 0) {
        NSTimeInterval interval = [[NSDate date]timeIntervalSince1970]*1000;
        NSTimeInterval currentTime = interval + [IMUserInterface obtainTimeoffset];
        NSString *timeString = [IMTimeHandleManger displayedTimeStringComparedCurrentTime:currentTime WithOriginalTime:topic.latestMessage.sendTime];
        self.timeLabel.text = [timeString componentsSeparatedByString:@" "].firstObject;
    }else {
        self.timeLabel.text = @"";
    }
    self.tipImageView.hidden = topic.unreadCount==0;
}

- (void)setupMockData {
    self.avatarImageView.image = [UIImage imageNamed:@"群聊-背景"];
    self.nameLabel.text = @"这是标题啦这是标题啦";
    self.messageLabel.text = @"这是最新的信息啦这是最新的信息啦这是最新的信息啦这是最新的信息啦这是最新的信息啦";
    self.timeLabel.text = @"2017.12.31 00:00";
    
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSTimeInterval interval = [[NSDate date]timeIntervalSince1970]*1000;
    NSTimeInterval currentTime = interval + [IMUserInterface obtainTimeoffset];
    NSString *timeString = [IMTimeHandleManger displayedTimeStringComparedCurrentTime:currentTime WithOriginalTime:time];
    self.timeLabel.text = [timeString componentsSeparatedByString:@" "].firstObject;
}
@end


