//
//  IMTextMessageBaseCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTextMessageBaseCell.h"


@implementation IMTextMessageBaseCell

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
    self.messageTextLabel = [[UILabel alloc] init];
    self.messageTextLabel.numberOfLines = 0;
    self.messageTextLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.messageTextLabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setupLayout {
    [super setupLayout];
    [self.messageBackgroundView addSubview:self.messageTextLabel];
    [self.messageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(11.f, 15.f, 18.f, 14.f));
    }];
}

- (void)setMessage:(IMTopicMessage *)message {
    [super setMessage:message];
    self.messageTextLabel.text = message.text;
}

@end
