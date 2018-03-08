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
        _height = [cell heigthtForMessageModel:self] ;
    }
    return _height;
}

- (void)setIsTimeVisible:(BOOL)isTimeVisible {
    if (!_isTimeVisible && isTimeVisible) {
        if (!_height) {
            IMMessageBaseCell *cell = [IMMessageCellFactory cellWithMessageModel:self];
            _height = [cell heigthtForMessageModel:self];
            _height += 35;
        }else {
            _height += 35;
        }
    }
     _isTimeVisible = isTimeVisible;
}
@end
