//
//  IMMessageCellDelegate.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMTopicMessage;
@class IMMember;

@protocol IMMessageCellDelegate <NSObject>

- (void)messageCellDidClickAvatarForUser:(IMMember *)user;

- (void)messageCellTap:(IMTopicMessage *)message;

- (void)messageCellLongPress:(IMTopicMessage *)message rect:(CGRect)rect;

- (void)messageCellDoubleClick:(IMTopicMessage *)message;

- (void)messageCellDidClickStateButton:(IMTopicMessage *)message rect:(CGRect)rect;

@end
