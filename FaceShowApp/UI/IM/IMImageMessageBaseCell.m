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
    self.messageImageview.contentMode = UIViewContentModeScaleAspectFill;
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
    [self.stateButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageBackgroundView.mas_centerY);
    }];
    
    [self.messageBackgroundView addSubview:self.messageImageview];
    [self.messageImageview addSubview:self.progressView];
    
    [self.messageImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)).priorityHigh();
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setModel:(IMChatViewModel *)model {
    IMTopicMessage *message = model.message;
    [super setModel:model];
    WEAK_SELF
    [[self.model                                                                                                      rac_valuesForKeyPath:@"percent" observer:self] subscribeNext:^(id x) {
        STRONG_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = [NSString stringWithFormat:@"%@",x];
        });
        
    }];
    [self updateSendStateWithMessage:message];
    if (self.messageImageview.image) {
        return;
    }
    if ([message imageWaitForSending]) {
        self.messageImageview.image = [message imageWaitForSending];
        CGSize size = [self.messageImageview.image nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
        [self.messageImageview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width, size.height)).priorityHigh();
        }];
    }else {
        WEAK_SELF
        [self.messageImageview sd_setImageWithURL:[NSURL URLWithString:message.viewUrl] placeholderImage:[UIImage imageNamed:@"图片发送失败"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            STRONG_SELF
            CGSize size = [self.messageImageview.image nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
            [self.messageImageview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size.width, size.height)).priorityHigh();
            }];
//            [self updateImageHeightWithModel:model imageHeight:size.height];
//            [self layoutIfNeeded];
        }];
    }
}

- (void)updateSendStateWithMessage:(IMTopicMessage *)message {
    if (message.sendState == MessageSendState_Sending) {
        self.progressView.hidden = NO;
    }else if (message.sendState == MessageSendState_Success) {
        self.progressView.hidden = YES;
    }else {
        self.progressView.hidden = YES;
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
    height += model.message.height;
//    __block CGSize size = CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth);
//    if (model.message.sendState != MessageSendState_Success) {
//        size = [[model.message imageWaitForSending] nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
//    }
//    height += size.height;
    
    return height;
}

//- (void)updateImageHeightWithModel:(IMChatViewModel *)model imageHeight:(CGFloat)imageHeight {
//    CGFloat height = 15;
//    //时间的高度 放到外面进行
//    //名字的高度
//    if (model.topicType == TopicType_Group) {//群聊显示名字
//        height += 20;
//    }else {
//        height += 0;
//    }
//    //聊天内容图片的高
//    height += imageHeight;
//    self.model.height = height;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellUpdateHeight:)]) {
//        [self.delegate messageCellUpdateHeight:self.model];
//    }
//}
@end
