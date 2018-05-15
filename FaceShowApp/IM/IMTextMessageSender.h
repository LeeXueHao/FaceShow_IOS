//
//  IMTextMessageSender.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTextMessage.h"

@interface IMTextMessageSender : NSObject

+ (IMTextMessageSender *)sharedInstance;

- (void)addTextMessage:(IMTextMessage *)msg;

@end
