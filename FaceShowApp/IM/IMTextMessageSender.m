//
//  IMTextMessageSender.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTextMessageSender.h"
#import "SaveTextMsgRequest.h"
#import "IMDatabaseManager.h"
#import "IMManager.h"
#import "IMConfig.h"
#import "IMRequestManager.h"
#import "IMConnectionManager.h"

@interface IMTextMessageSender()
@property (nonatomic, strong) NSMutableArray<IMTextMessage *> *msgArray;
@property (nonatomic, assign) BOOL isMsgSending;
@property (nonatomic, strong) SaveTextMsgRequest *saveTextMsgRequest;
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
        message = [self textMsgFromCurrentUserWithText:msg.text topicID:msg.topicID uniqueID:reqId];
        msg.uniqueID = reqId;
    }
    message.sendState = MessageSendState_Sending;
    message.sendTime = [[NSDate date]timeIntervalSince1970]*1000 + [IMRequestManager sharedInstance].timeoffset;
    [[IMDatabaseManager sharedInstance]saveMessage:message];
    
    [self.msgArray addObject:msg];
    [self checkAndSend];
}

- (IMTopicMessage *)textMsgFromCurrentUserWithText:(NSString *)text
                                           topicID:(int64_t)topicID
                                          uniqueID:(NSString *)uniqueID{
    IMTopicMessage *message = [[IMTopicMessage alloc]init];
    message.type = MessageType_Text;
    message.text = text;
    message.topicID = topicID;
    message.channel = [IMConfig generateUniqueID];
    message.uniqueID = uniqueID;
    message.sender = [[IMManager sharedInstance]currentMember];
    return message;
}

- (void)checkAndSend{
    if (self.isMsgSending || self.msgArray.count == 0) {
        return;
    }
    self.isMsgSending = YES;
    IMTextMessage *msg = [self.msgArray firstObject];
    if (!msg.topicID) {
        WEAK_SELF
        [[IMRequestManager sharedInstance]requestNewTopicWithMember:msg.otherMember completeBlock:^(IMTopic *topic, NSError *error) {
            STRONG_SELF
            if (error) {
                [self messageSentFailed:msg];
                [self sendNext];
                return;
            }
            // 更新topicid
            IMTopicMessage *message = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:msg.uniqueID];
            message.topicID = topic.topicID;
            [[IMDatabaseManager sharedInstance]saveMessage:message];
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
