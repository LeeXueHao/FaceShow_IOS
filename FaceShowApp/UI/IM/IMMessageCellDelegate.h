//
//  IMMessageCellDelegate.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMChatViewModel;
@class IMMember;
@class IMMessageBaseCell;

@protocol IMMessageCellDelegate <NSObject>

- (void)messageCellDidClickAvatarForUser:(IMMember *)user;

- (void)messageCellTap:(IMMessageBaseCell *)cell;

- (void)messageCellLongPress:(IMChatViewModel *)model rect:(CGRect)rect;

- (void)messageCellDoubleClick:(IMChatViewModel *)mmodel;

- (void)messageCellDidClickStateButton:(IMChatViewModel *)model rect:(CGRect)rect;

@end
