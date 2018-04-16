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
//        CGRect rect = self.messageBackgroundView.frame;
        [self.delegate messageCellTap:self];
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
    CGSize size;
    if (model.message.height<= 0 ) {
        size = CGSizeMake(kMaxImageSizeHeight, kMaxImageSizeHeight);
    }else {
        size = [self aspectFitOriginalSize:CGSizeMake(model.message.width / [UIScreen mainScreen].scale, model.message.height / [UIScreen mainScreen].scale) withReferenceSize:CGSizeMake(kMaxImageSizeHeight, kMaxImageSizeHeight)];
        if (size.height < kMinImageSizeHeight) {
            size.height = kMinImageSizeHeight;
        }
        if (size.width < kMinImageSizewidth) {
            size.width = kMinImageSizewidth;
        }
    }
    [self.messageImageview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width, size.height)).priorityHigh();
    }];
    UIImage *localImage = [message imageWaitForSending];
    UIImage *placeholderImage = localImage? localImage:[UIImage imageNamed:@"图片发送失败"];
    [self.messageImageview sd_setImageWithURL:[NSURL URLWithString:message.viewUrl] placeholderImage:placeholderImage];
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
    CGSize size;
    if (model.message.height<= 0 ) {
        size = CGSizeMake(kMaxImageSizeHeight, kMaxImageSizeHeight);
    }else {
        size = [self aspectFitOriginalSize:CGSizeMake(model.message.width / [UIScreen mainScreen].scale, model.message.height / [UIScreen mainScreen].scale) withReferenceSize:CGSizeMake(kMaxImageSizeHeight, kMaxImageSizeHeight)];
        if (size.height < kMinImageSizeHeight) {
            size.height = kMinImageSizeHeight;
        }
        if (size.width < kMinImageSizewidth) {
            size.width = kMinImageSizewidth;
        }
    }
    height += size.height;
    
    return height;
}

- (CGSize)aspectFitOriginalSize:(CGSize)originalSize withReferenceSize:(CGSize)referenceSize {
    CGFloat scaleW = originalSize.width / referenceSize.width;
    CGFloat scaleH = originalSize.height / referenceSize.height;
    CGFloat scale = MAX(scaleH, scaleW);
    CGSize scaledSize = CGSizeMake(originalSize.width / scale, originalSize.height / scale);
    return scaledSize;
}
@end
