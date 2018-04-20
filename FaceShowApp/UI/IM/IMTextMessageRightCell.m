//
//  IMTextMessageRightCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTextMessageRightCell.h"

@implementation IMTextMessageRightCell

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
        UIImage *image = [UIImage imageNamed:@"发送蓝底"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 15, 10, 15) resizingMode:UIImageResizingModeStretch];
        self.messageBackgroundView.image = image;
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    self.messageTextLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
}

- (void)setupLayout {
    [super setupLayout];
    [self.messageTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12.f, 10.f, 12.f, 14.f));
    }];
}

- (void)setModel:(IMChatViewModel *)model {
    [super setModel:model];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    
    self.usernameLabel.hidden = YES;
    [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarButton.mas_top);
        make.right.equalTo(self.avatarButton.mas_left).offset(-5.f).priorityHigh();
        make.bottom.mas_equalTo(0.f);
        make.left.mas_greaterThanOrEqualTo(65);
    }];
    
    [self.stateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageBackgroundView.mas_centerY);
        make.right.equalTo(self.messageBackgroundView.mas_left).offset(-5.f);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (CGFloat)heigthtForMessageModel:(IMChatViewModel *)model {
    CGFloat height = [super heigthtForMessageModel:model];
    //名字的高度
    if (model.topicType == TopicType_Group) {//群聊显示名字
        height -= 20;
    }else {
        height -= 0;
    }
    return height;
}

@end
