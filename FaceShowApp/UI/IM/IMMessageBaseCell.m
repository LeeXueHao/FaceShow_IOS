//
//  IMMessageBaseCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageBaseCell.h"
#import "IMTimeHandleManger.h"

@interface IMMessageBaseCell()
@end

@implementation IMMessageBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"c9cdce"];
    self.timeLabel.layer.cornerRadius = 5.0f;
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    
    self.avatarButton = [[UIButton alloc] init];
    self.avatarButton.layer.cornerRadius = 6.f;
    self.avatarButton.clipsToBounds = YES;
    [self.avatarButton setImage:[UIImage imageNamed:@"我个人头像默认图"] forState:UIControlStateNormal];
    [self.avatarButton addTarget:self action:@selector(avatarButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.usernameLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.messageBackgroundView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 30, 25, 30) resizingMode:UIImageResizingModeStretch];
    self.messageBackgroundView.image = image;
    [self.messageBackgroundView setUserInteractionEnabled:YES];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMsgBGView:)];
    [self.messageBackgroundView addGestureRecognizer:longPressGR];
    
    UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabpMsgBGView)];
    [doubleTapGR setNumberOfTapsRequired:2];
    [self.messageBackgroundView addGestureRecognizer:doubleTapGR];
    
    self.stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stateButton addTarget:self action:@selector(stateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)avatarButtonDown:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidClickAvatarForUser:)]) {
        [self.delegate messageCellDidClickAvatarForUser:self.message.sender];
    }
}

- (void)longPressMsgBGView:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    [self.messageBackgroundView setHighlighted:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellLongPress:rect:)]) {
        CGRect rect = self.messageBackgroundView.frame;
        rect.size.height -= 10;     // 北京图片底部空白区域
        [self.delegate messageCellLongPress:self.message rect:rect];
    }
}

- (void)doubleTabpMsgBGView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDoubleClick:)]) {
        [self.delegate messageCellDoubleClick:self.message];
    }
}

- (void)stateButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidClickStateButton: rect:)]) {
        CGRect rect = self.stateButton.frame;
        rect.size.height -= 10;     // 北京图片底部空白区域
        [self.delegate messageCellDidClickStateButton:self.message rect:rect];
    }
}

- (void)setupLayout {
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.avatarButton];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.messageBackgroundView];
    [self.contentView addSubview:self.stateButton];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(15.f);
        make.left.mas_equalTo(15.f);
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarButton.mas_top);
        make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(10.f);
        make.height.mas_equalTo(14.f);
    }];
    
    [self.messageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(6.f);
        make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(5.f).priorityHigh();
        make.bottom.mas_equalTo(0.f);
        make.right.mas_lessThanOrEqualTo(-75 * kPhoneWidthRatio);
    }];
    
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageBackgroundView.mas_centerY).offset(-5);
        make.left.equalTo(self.messageBackgroundView.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setMessage:(IMTopicMessage *)message {
    if (_message && [_message.uniqueID isEqualToString:message.uniqueID]) {
        [self setupSendStateWithMessage:message];
        return;
    }
    _message = message;
    if (message.isTimeVisible) {
        NSString *timeString = [IMTimeHandleManger compareCurrentTimeWithOriginalTimeObtainDisplayedTimeString:message.sendTime];
        CGRect rect = [timeString boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(rect.size.width + 12);
            make.height.mas_equalTo(20);
        }];
        self.timeLabel.text = timeString;
    }else {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    [self.usernameLabel setText:message.sender.name];
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:message.sender.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"我个人头像默认图"]];
    [self setupSendStateWithMessage:message];
    DDLogDebug(@"内容为:%@-----状态为%@",message.text,@(message.sendState));
}

- (void)setupSendStateWithMessage:(IMTopicMessage *)message {
    if (message.sendState == MessageSendState_Sending) {
        self.stateButton.enabled = NO;
        self.stateButton.backgroundColor = [UIColor yellowColor];
    }else if (message.sendState == MessageSendState_Failed) {
        self.stateButton.backgroundColor = [UIColor redColor];
        self.stateButton.enabled = YES;
    }else {
        self.stateButton.backgroundColor = [UIColor greenColor];
        self.stateButton.enabled = NO;
    }
}

- (void)setTopicType:(TopicType)topicType {
    if (topicType == TopicType_Private) {
        self.usernameLabel.hidden = YES;
        [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.usernameLabel.mas_bottom);
        }];
    }else {
        self.usernameLabel.hidden = NO;
        [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(14.f);
        }];
        [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(6.f);
        }];
    }
}
@end

