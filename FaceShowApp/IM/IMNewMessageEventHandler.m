//
//  IMNewMessageEventHandler.m
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMNewMessageEventHandler.h"
#import "TopicMsg.pbobjc.h"
#import "IMDatabaseManager.h"
#import <NSString+HTML.h>

@implementation IMNewMessageEventHandler
- (void)handleData:(NSData *)data inTopic:(NSString *)topic {
    NSError *error = nil;
    TopicMsg *msg = [TopicMsg parseFromData:data error:&error];
    if (error) {
        NSLog(@"parse error:%@",error.localizedDescription);
        return;
    }
    IMTopicMessage *message = [[IMTopicMessage alloc]init];
    message.type = msg.contentType;
    message.text = msg.contentData.msg;
    message.topicID = msg.topicId;
    message.channel = topic;
    message.uniqueID = msg.reqId;
    message.thumbnail = msg.contentData.thumbnail;
    message.viewUrl = msg.contentData.viewURL;
    message.sendTime = msg.sendTime;
    message.messageID = msg.id_p;
    message.sendState = MessageSendState_Success;
    message.width = msg.contentData.width;
    message.height = msg.contentData.height;
    while (![[message.text stringByReplacingHTMLEntities]isEqualToString:message.text]) {
        message.text = [message.text stringByReplacingHTMLEntities];
    }
    
    IMMember *sender = [[IMMember alloc]init];
    sender.memberID = msg.senderId;
    sender.name = msg.senderName;
    message.sender = sender;
    
    [[IMDatabaseManager sharedInstance]saveMessage:message];
}

@end
