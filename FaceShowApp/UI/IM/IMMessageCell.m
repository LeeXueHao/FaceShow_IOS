//
//  IMMessageCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageCell.h"

@interface IMMessageCell()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation IMMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.leftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).multipliedBy(0.5);
    }];
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.contentView.mas_left).multipliedBy(0.5);
    }];
}

- (void)setMessage:(IMTopicMessage *)message {
    _message = message;
    if ([message isFromCurrentUser]) {
        self.leftLabel.text = @"";
        NSString *stateStr = message.sendState==MessageSendState_Sending? @"[sending...]" :@"";
        self.rightLabel.text = [NSString stringWithFormat:@"%@%@",stateStr,message.text];
    }else {
        self.leftLabel.text = message.text;
        self.rightLabel.text = @"";
    }
}

@end
