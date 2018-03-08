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
//    if (!_height) {
//        IMMessageBaseCell *cell = [IMMessageCellFactory cellWithMessageModel:self];
//        _height = [cell heigthtForMessageModel:self];
//    }
//    return _height;
    IMMessageBaseCell *cell = [IMMessageCellFactory cellWithMessageModel:self];
    return [cell heigthtForMessageModel:self];
}

@end
