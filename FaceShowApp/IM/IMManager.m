//
//  IMManager.m
//  TestIM
//
//  Created by niuzhaowang on 2017/12/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "IMManager.h"
#import "IMConnectionManager.h"
#import "IMDatabaseManager.h"
#import "IMServiceManager.h"
#import "IMImageMessageSender.h"
#import "IMTextMessageSender.h"

@interface IMManager()
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) IMMember *currentMember;
@property (nonatomic, strong) NSString *sceneID;
@end

@implementation IMManager
+ (IMManager *)sharedInstance {
    static IMManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMManager alloc] init];
    });
    return manager;
}

- (void)setupWithCurrentMember:(IMMember *)member token:(NSString *)token {
    self.currentMember = member;
    self.token = token;
    [[IMDatabaseManager sharedInstance]saveMember:member];
    // 稍微加点延迟再发是为了等所有的配置都完成。
    [self performSelector:@selector(resendAllUncompletedMessages) withObject:nil afterDelay:0.1];
}

- (void)resendAllUncompletedMessages {
    NSArray *messages = [[IMDatabaseManager sharedInstance]findAllUncompletedMessages];
    for (IMTopicMessage *msg in messages) {
        IMTopic *topic = [[IMDatabaseManager sharedInstance]findTopicWithID:msg.topicID];
        if (msg.type == MessageType_Image) {
            [self resendUncompleteImageMessage:msg inTopic:topic];
        }else if (msg.type == MessageType_Text) {
            [self resendUncompleteTextMessage:msg inTopic:topic];
        }
    }
}

- (void)resendUncompleteImageMessage:(IMTopicMessage *)msg inTopic:(IMTopic *)topic {
    IMImageMessage *imageMsg = [[IMImageMessage alloc]init];
    imageMsg.topicID = msg.topicID;
    imageMsg.groupID = topic.groupID;
    imageMsg.image = [[IMImageMessageSender sharedInstance]cacheImageWithMessageUniqueID:msg.uniqueID];
    imageMsg.width = msg.width;
    imageMsg.height = msg.height;
    imageMsg.uniqueID = msg.uniqueID;
    for (IMMember *member in topic.members) {
        if (member.memberID != msg.sender.memberID) {
            imageMsg.otherMember = member;
            break;
        }
    }
    [[IMImageMessageSender sharedInstance]resendUncompleteMessage:imageMsg];
}

- (void)resendUncompleteTextMessage:(IMTopicMessage *)msg inTopic:(IMTopic *)topic {
    IMTextMessage *textMsg = [[IMTextMessage alloc]init];
    textMsg.topicID = msg.topicID;
    textMsg.groupID = topic.groupID;
    textMsg.text = msg.text;
    textMsg.uniqueID = msg.uniqueID;
    for (IMMember *member in topic.members) {
        if (member.memberID != msg.sender.memberID) {
            textMsg.otherMember = member;
            break;
        }
    }
    [[IMTextMessageSender sharedInstance]resendUncompleteMessage:textMsg];
}

- (void)setupWithSceneID:(NSString *)sceneID {
    self.sceneID = sceneID;
}

- (void)startConnection {
    [[IMServiceManager sharedInstance]start];
}

- (void)stopConnection {
    [[IMServiceManager sharedInstance]stop];
}

@end
