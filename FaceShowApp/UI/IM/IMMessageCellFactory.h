//
//  IMMessageCellFactory.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessageBaseCell.h"
#import "IMTextMessageBaseCell.h"
#import "IMTextMessageLeftCell.h"
#import "IMTextMessageRightCell.h"
#import "IMTopicMessage.h"

@interface IMMessageCellFactory : NSObject

+ (IMMessageBaseCell *)cellWithMessage:(IMTopicMessage *)message;

@end
