//
//  IMTextMessageLeftCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTextMessageLeftCell.h"

@implementation IMTextMessageLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(IMTopicMessage *)message {
    [super setMessage:message];
    self.stateButton.hidden = YES;
}
@end
