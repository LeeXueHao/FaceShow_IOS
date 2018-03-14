//
//  TopicMsgData.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TopicMsgData.h"
#import "IMConfig.h"

@implementation TopicMsgData_contentData

@end
@implementation TopicMsgData_topicMsg
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"msgId"}];
}

- (IMTopicMessage *)toIMTopicMessage {
    IMTopicMessage *message = [[IMTopicMessage alloc]init];
    message.type = self.contentType.longLongValue;
    message.sendTime = self.sendTime.doubleValue;
    message.text = self.contentData.msg;
    message.thumbnail = self.contentData.thumbnail;
    message.viewUrl = self.contentData.viewUrl;
    message.sendState = MessageSendState_Success;
    message.topicID = self.topicId.longLongValue;
    message.channel = [IMConfig topicForTopicID:message.topicID];
    message.uniqueID = self.reqId;
    message.messageID = self.msgId.longLongValue;
    message.width = self.contentData.width.longLongValue;
    message.height = self.contentData.height.longLongValue;
    
    IMMember *sender = [[IMMember alloc]init];
    sender.memberID = self.senderId.longLongValue;
    message.sender = sender;
    return message;
}
@end
@implementation TopicMsgData

@end
