//
//  IMTopicMessage.h
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMember.h"

typedef NS_ENUM(int64_t, MessageType) {
    MessageType_Text = 10,
    MessageType_Image = 20,
    MessageType_Video = 30
};

typedef NS_ENUM(int64_t, MessageSendState) {
    MessageSendState_Sending,
    MessageSendState_Success,
    MessageSendState_Failed
};

@interface IMTopicMessage : NSObject
@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) NSTimeInterval sendTime;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *viewUrl;
@property (nonatomic, assign) MessageSendState sendState;
@property (nonatomic, assign) int64_t index;
@property (nonatomic, assign) int64_t topicID;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, assign) int64_t messageID;
@property (nonatomic, assign) int64_t width;
@property (nonatomic, assign) int64_t height;
@property (nonatomic, strong) IMMember *sender;

- (BOOL)isFromCurrentUser;
- (UIImage *)imageWaitForSending;
@end
