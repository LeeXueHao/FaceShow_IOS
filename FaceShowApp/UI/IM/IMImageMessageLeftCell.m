//
//  IMImageMessageLeftCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMImageMessageLeftCell.h"

@implementation IMImageMessageLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(IMChatViewModel *)model {
    [super setModel:model];
    self.stateButton.hidden = YES;
}

@end
