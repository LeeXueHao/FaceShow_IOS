//
//  IMImageMessageBaseCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMImageMessageBaseCell.h"

static const CGFloat kMaxImageSizeWidth = 140;

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
}

- (void)setupLayout {
    [super setupLayout];
    [self.messageBackgroundView addSubview:self.messageImageview];
    [self.messageImageview addSubview:self.progressView];
    
//    CGSize size = [self.messageImageview.image nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
    [self.messageImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setMessage:(IMTopicMessage *)message {
    if (self.message && [self.message.uniqueID isEqualToString:message.uniqueID]) {
        //更新图片
        [self updateSendStateWithMessage:message];
        WEAK_SELF
        [self.messageImageview sd_setImageWithURL:[NSURL URLWithString:message.thumbnail] placeholderImage:[UIImage imageNamed:@"背景图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            STRONG_SELF
            CGSize size = [self.messageImageview.image nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
            [self.messageImageview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size.width, size.height));
            }];
        }];
        return;
    }
    [super setMessage:message];
    [self updateSendStateWithMessage:message];
    WEAK_SELF
    [self.messageImageview sd_setImageWithURL:[NSURL URLWithString:message.thumbnail] placeholderImage:[UIImage imageNamed:@"背景图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF
        CGSize size = [self.messageImageview.image nyx_aspectFitSizeWithSize:CGSizeMake(kMaxImageSizeWidth, kMaxImageSizeWidth)];
        [self.messageImageview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
        }];
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
@end
