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
    self.messageImageview = [[UIImageView alloc]init];
    self.messageImageview.backgroundColor = [UIColor redColor];
    self.messageBackgroundView.image = [[UIImage alloc]init];
}

- (void)setupLayout {
    [self.messageBackgroundView addSubview:self.messageImageview];
    [self.messageImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)setMessage:(IMTopicMessage *)message {
    if (self.message && [self.message.uniqueID isEqualToString:message.uniqueID]) {
        //更新图片
        return;
    }
    [super setMessage:message];
    [self.messageImageview sd_setImageWithURL:[NSURL URLWithString:message.thumbnail] placeholderImage:[UIImage imageNamed:@"聊聊-背景"]];
}
@end
