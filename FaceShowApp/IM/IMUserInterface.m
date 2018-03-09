//
//  IMUserInterface.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMUserInterface.h"
#import "IMRequestManager.h"
#import "IMDatabaseManager.h"
#import "IMTextMessageSender.h"

@implementation IMUserInterface

+ (void)sendTextMessageWithText:(NSString *)text topicID:(int64_t)topicID {
    [self sendTextMessageWithText:text topicID:topicID uniqueID:nil];
}

+ (void)sendTextMessageWithText:(NSString *)text topicID:(int64_t)topicID uniqueID:(NSString *)uniqueID {
    IMTextMessage *msg = [[IMTextMessage alloc]init];
    msg.text = text;
    msg.topicID = topicID;
    msg.uniqueID = uniqueID;
    
    [[IMTextMessageSender sharedInstance]addTextMessage:msg];
}

+ (void)sendTextMessageWithText:(NSString *)text toMember:(IMMember *)member {
    IMTextMessage *msg = [[IMTextMessage alloc]init];
    msg.text = text;
    msg.otherMember = member;
    
    [[IMTextMessageSender sharedInstance]addTextMessage:msg];
}

+ (NSArray<IMTopic *> *)findAllTopics {
    NSArray<IMTopic *> *topics = [[IMDatabaseManager sharedInstance]findAllTopics];
    NSMutableArray *groupArray = [NSMutableArray array];
    NSMutableArray *privateArray = [NSMutableArray array];
    for (IMTopic *topic in topics) {
        if (topic.type == TopicType_Private) {
            [privateArray addObject:topic];
        }else {
            [groupArray addObject:topic];
        }
    }
    [groupArray sortedArrayUsingComparator:^NSComparisonResult(IMTopic *  _Nonnull obj1, IMTopic *  _Nonnull obj2) {
        return obj1.latestMessage.sendTime < obj2.latestMessage.sendTime;
    }];
    [privateArray sortedArrayUsingComparator:^NSComparisonResult(IMTopic *  _Nonnull obj1, IMTopic *  _Nonnull obj2) {
        return obj1.latestMessage.sendTime < obj2.latestMessage.sendTime;
    }];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:groupArray];
    [array addObjectsFromArray:privateArray];
    return array;
}

+ (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    [[IMDatabaseManager sharedInstance]findMessagesInTopic:topicID count:count asending:asending completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
        completeBlock(array, YES);
    }];
}

+ (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                  beforeMsg:(IMTopicMessage *)msg
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    if (!msg) {
        msg = [[IMTopicMessage alloc]init];
        msg.messageID = INT64_MAX;
        msg.index = INT64_MAX;
    }
    if (msg.messageID == 0) {
        msg.messageID = INT64_MAX;
    }
    [[IMDatabaseManager sharedInstance]findMessagesInTopic:topicID count:count beforeIndex:msg.index completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
        if (array.count > 0) {
            completeBlock(array, YES);
        }else {
            [[IMRequestManager sharedInstance]requestTopicMsgsWithTopicID:topicID startID:msg.messageID asending:NO dataNum:count+1 completeBlock:^(NSArray<IMTopicMessage *> *msgs, NSError *error) {
                BOOL more = msgs.count>count;
                if (more) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:msgs];
                    [array removeLastObject];
                    completeBlock(array, more);
                }else {
                    completeBlock(msgs, more);
                }
            }];
        }
    }];
}

+ (void)clearDirtyMessages {
    [[IMDatabaseManager sharedInstance] clearDirtyMessages];
}

+ (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID {
    [[IMDatabaseManager sharedInstance] resetUnreadMessageCountWithTopicID:topicID];
}
@end
