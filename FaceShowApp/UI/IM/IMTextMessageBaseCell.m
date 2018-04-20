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
    self.messageTextLabel.font = [UIFont systemFontOfSize:16.0f];
}

- (void)setupLayout {
    [super setupLayout];
    [self.messageBackgroundView addSubview:self.messageTextLabel];
    [self.messageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12.f, 14.f, 12.f, 10.f));
    }];
}

- (void)setModel:(IMChatViewModel *)model {
    [super setModel:model];
    self.messageTextLabel.text = model.message.text;
}

- (CGFloat)heigthtForMessageModel:(IMChatViewModel *)model {
    IMTopicMessage *message = model.message;
    CGFloat height = 15;
    //时间的高度 放到外面进行
    //名字的高度
    if (model.topicType == TopicType_Group) {//群聊显示名字
        height += 20;
    }else {
        height += 0;
    }
    //聊天内容文字的高
    CGSize textSize = [message.text boundingRectWithSize:CGSizeMake([self textMaxWidth], MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]} context:nil].size;
    height += ceil(textSize.height);
    //文字距离背景上下的高度
    height += 24;
    
    return height;
}

- (CGFloat)textMaxWidth {
    return SCREEN_WIDTH - (15 + 40 + 5 + 4 + 10 + 10 + 65);
}

@end
