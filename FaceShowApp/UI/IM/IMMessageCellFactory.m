//
//  IMMessageCellFactory.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageCellFactory.h"

@implementation IMMessageCellFactory

+ (IMMessageBaseCell *)cellWithMessageModel:(IMChatViewModel *)model {
    IMTopicMessage *message = model.message;
    MessageType type = message.type;
    if (type == MessageType_Text) {
        if ([message isFromCurrentUser]) {
            return [[IMTextMessageRightCell alloc]init];
        }else {
            return [[IMTextMessageLeftCell alloc]init];
        }
    }else if (type == MessageType_Image) {
        if ([message isFromCurrentUser]) {
            return [[IMImageMessageRightCell alloc]init];
        }else {
            return [[IMImageMessageLeftCell alloc]init];
        }
    }else {
        return [[IMMessageBaseCell alloc]init];
    }
}

@end
