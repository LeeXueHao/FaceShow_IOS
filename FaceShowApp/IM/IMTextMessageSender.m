//
//  IMTextMessageSender.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTextMessageSender.h"
#import "IMDatabaseManager.h"
#import "IMManager.h"
#import "IMConfig.h"
#import "IMRequestManager.h"
#import "IMConnectionManager.h"

@interface IMTextMessageSender()
@property (nonatomic, strong) NSMutableArray<IMTextMessage *> *msgArray;
@property (nonatomic, assign) BOOL isMsgSending;
@end

@implementation IMTextMessageSender

+ (IMTextMessageSender *)sharedInstance {
    static IMTextMessageSender *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMTextMessageSender alloc] init];
        manager.msgArray = [NSMutableArray array];
        manager.isMsgSending = NO;
    });
    return manager;
}

- (void)addTextMessage:(IMTextMessage *)msg {
    IMTopicMessage *message = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:msg.uniqueID];
    if (!message) {
        NSString *reqId = [IMConfig generateUniqueID];
        msg.uniqueID = reqId;
        message = [self textTopicMsgFromMessage:msg];
    }
    message.sendState = MessageSendState_Sending;
    message.sendTime = [[NSDate date]timeIntervalSince1970]*1000 + [IMRequestManager sharedInstance].timeoffset;
    [[IMDatabaseManager sharedInstance]saveMessage:message];
    
    [self.msgArray addObject:msg];
    [self checkAndSend];
}

- (IMTopicMessage *)textTopicMsgFromMessage:(IMTextMessage *)msg {
    IMTopicMessage *message = [[IMTopicMessage alloc]init];
    message.type = MessageType_Text;
    message.text = msg.text;
    message.topicID = msg.topicID;
    message.channel = [IMConfig generateUniqueID];
    message.uniqueID = msg.uniqueID;
    message.sender = [[IMManager sharedInstance]currentMember];
    return message;
}

- (void)checkAndSend{
    if (self.isMsgSending || self.msgArray.count == 0) {
        return;
    }
    self.isMsgSending = YES;
    IMTextMessage *msg = [self.msgArray firstObject];
    if ([[IMDatabaseManager sharedInstance]isTempTopicID:msg.topicID]) {
        WEAK_SELF
        [[IMRequestManager sharedInstance]requestNewTopicWithMember:msg.otherMember fromGroup:msg.groupID completeBlock:^(IMTopic *topic, NSError *error) {
            STRONG_SELF
            if (error) {
                [self messageSentFailed:msg];
                [self sendNext];
                return;
            }
            // 订阅新的topic
            [[IMDatabaseManager sharedInstance]saveTopic:topic];
            [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:topic.topicID]];
            
            msg.topicID = topic.topicID;
            [self sendMessage:msg];
        }];
    }else {
        [self sendMessage:msg];
    }
}

- (void)sendMessage:(IMTextMessage *)textMsg {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestSaveTextMsgWithMsg:textMsg completeBlock:^(IMTopicMessage *msg, NSError *error) {
        STRONG_SELF
        if (error) {
            [self messageSentFailed:textMsg];
        }else {
            [[IMDatabaseManager sharedInstance]saveMessage:msg];
        }
        [self sendNext];
    }];
}

- (void)messageSentFailed:(IMTextMessage *)msg {
    IMTopicMessage *message = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:msg.uniqueID];
    message.sendState = MessageSendState_Failed;
    [[IMDatabaseManager sharedInstance]saveMessage:message];
}

- (void)sendNext {
    [self.msgArray removeObjectAtIndex:0];
    self.isMsgSending = NO;
    [self checkAndSend];
}

@end
