//
//  IMChatViewModel.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMChatViewModel.h"
#import "IMMessageBaseCell.h"
#import "IMMessageCellFactory.h"

@implementation IMChatViewModel

- (CGFloat)height {
    if (!_height) {
        IMMessageBaseCell *cell = [IMMessageCellFactory cellWithMessageModel:self];
        _height = [cell heigthtForMessageModel:self];//除去时间之外的高度
    }
    if (_isTimeVisible) {//显示时间的话需要再加上35的高度
        return _height + 35;
    }
    return _height;
}

@end
