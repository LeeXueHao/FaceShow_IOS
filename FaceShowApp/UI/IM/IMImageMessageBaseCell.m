//
//  IMImageMessageBaseCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMImageMessageBaseCell.h"

@implementation IMImageMessageBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setupUI {
    [super setupUI];
    self.messageImageview = [[UIImageView alloc]init];
    self.messageImageview.backgroundColor = [UIColor redColor];
    self.messageImageview.layer.cornerRadius = 6.0f;
    self.messageImageview.clipsToBounds = YES;
    
    self.progressView = [[IMImageSendingProgressView alloc]init];
    
    self.messageBackgroundView.image = [[UIImage alloc]init];
    self.messageBackgroundView.layer.cornerRadius = 6.0f;
    self.messageBackgroundView.clipsToBounds = YES;
    
    self.messageBackgroundView.userInteractionEnabled = YES;
    self.messageImageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.messageBackgroundView addGestureRecognizer:tap];
}

- (void)tapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellTap:)]) {
        [self.delegate messageCellTap:self.model];
    }
}

- (void)setupLayout {
    [super setupLayout];
    [self.messageBackgroundView addSubview:self.messageImageview];
    [self.messageImageview addSubview:self.progressView];
    
    [self.messageImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setModel:(IMChatViewModel *)model {
    IMTopicMessage *message = model.message;
    if (self.model && [self.model.message.uniqueID isEqualToString:model.message.uniqueID]) {
        //更新图片
        [self updateSendStateWithMessage:message];
        [self.messageImageview sd_setImageWithURL:[NSURL URLWithString:message.thumbnail] placeholderImage:[UIImage imageNamed:@"背景图片"]];
        return;
    }
    [super setModel:model];
    [self updateSendStateWithMessage:message];
//    self.messageImageview.image = [UIImage imageWithContentsOfFile:@""];
    self.messageImageview.image = [UIImage imageNamed:@"背景图片"];
    CGSize size = [self.messageImageview.image nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
    [self.messageImageview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width, size.height)).priorityHigh();
    }];
}

- (void)updateSendStateWithMessage:(IMTopicMessage *)message {
    if (message.sendState == MessageSendState_Sending) {
        self.progressView.hidden = NO;
        self.progressView.progress = @"15";
        self.stateButton.hidden = YES;
    }else if (message.sendState == MessageSendState_Success) {
        self.progressView.hidden = YES;
        self.stateButton.hidden = YES;
    }else {
        self.progressView.hidden = YES;
        self.stateButton.hidden = NO;
    }
}

- (CGFloat)heigthtForMessageModel:(IMChatViewModel *)model {
    CGFloat height = 15;
    //时间的高度 放到外面进行
    //名字的高度
    if (model.topicType == TopicType_Group) {//群聊显示名字
        height += 20;
    }else {
        height += 0;
    }
    //聊天内容图片的高
    CGSize size = [[UIImage imageNamed:@"背景图片"] nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];//这里的图片需要等数据结构出来后确定
    height += size.height;
    
    return height;
}
@end
