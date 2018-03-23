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
#import "IMImageMessageSender.h"
#import "IMManager.h"

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

+ (void)sendTextMessageWithText:(NSString *)text toMember:(IMMember *)member fromGroup:(int64_t)groupID{
    IMTopic *tempTopic = [IMUserInterface generateTempTopicWithMember:member];
    IMTextMessage *msg = [[IMTextMessage alloc]init];
    msg.text = text;
    msg.otherMember = member;
    msg.groupID = groupID;
    msg.topicID = tempTopic.topicID;
    
    [[IMTextMessageSender sharedInstance]addTextMessage:msg];
}

+ (void)sendImageMessageWithImage:(UIImage *)image topicID:(int64_t)topicID {
    [self sendImageMessageWithImage:image topicID:topicID uniqueID:nil];
}

+ (void)sendImageMessageWithImage:(UIImage *)image topicID:(int64_t)topicID uniqueID:(NSString *)uniqueID {
    IMImageMessage *msg = [[IMImageMessage alloc]init];
    msg.image = image;
    msg.topicID = topicID;
    msg.uniqueID = uniqueID;
    
    [[IMImageMessageSender sharedInstance]addImageMessage:msg];
}

+ (void)sendImageMessageWithImage:(UIImage *)image toMember:(IMMember *)member fromGroup:(int64_t)groupID{
    IMTopic *tempTopic = [IMUserInterface generateTempTopicWithMember:member];
    IMImageMessage *msg = [[IMImageMessage alloc]init];
    msg.image = image;
    msg.otherMember = member;
    msg.groupID = groupID;
    msg.topicID = tempTopic.topicID;
    
    [[IMImageMessageSender sharedInstance]addImageMessage:msg];
}

+ (IMTopic *)generateTempTopicWithMember:(IMMember *)member {
    IMTopic *topic = [[IMTopic alloc]init];
    topic.type = TopicType_Private;
    topic.topicID = [[IMDatabaseManager sharedInstance]generateTempTopicID];
    topic.members = @[member,[IMManager sharedInstance].currentMember];
    [[IMDatabaseManager sharedInstance]saveTopic:topic];
    return topic;
}

+ (NSArray<IMTopic *> *)findAllTopics {
    NSArray<IMTopic *> *topics = [[IMDatabaseManager sharedInstance]findAllTopics];
    NSMutableArray *groupArray = [NSMutableArray array];
    NSMutableArray *privateArray = [NSMutableArray array];
    for (IMTopic *topic in topics) {
        if (topic.members.count == 0) {
            continue;
        }
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

+ (void)findMessagesInTopic:(IMTopic *)topic
                      count:(NSUInteger)count
                  beforeMsg:(IMTopicMessage *)msg
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore, NSError *error))completeBlock {
    if (!msg) {
        msg = [[IMTopicMessage alloc]init];
        msg.messageID = INT64_MAX;
        msg.index = INT64_MAX;
    }
    if (msg.messageID == 0) {
        msg.messageID = INT64_MAX;
    }
    [[IMDatabaseManager sharedInstance]findMessagesInTopic:topic.topicID count:count beforeIndex:msg.index completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
        if (topic.type == TopicType_Private) {
            completeBlock(array, hasMore, nil);
        }else if (topic.type == TopicType_Group){
            if (array.count > 0) {
                completeBlock(array, YES, nil);
            }else {
                // 有真实messageID时，返回的消息会包含当前的message，所以需要多取一个
                NSInteger offset = msg.messageID!=INT64_MAX;
                [[IMRequestManager sharedInstance]requestTopicMsgsWithTopicID:topic.topicID startID:msg.messageID asending:NO dataNum:count+1+offset completeBlock:^(NSArray<IMTopicMessage *> *msgs, NSError *error) {
                    if (error) {
                        completeBlock(nil, NO, error);
                        return;
                    }
                    BOOL more = (msgs.count-offset)>count;
                    NSMutableArray *array = [NSMutableArray arrayWithArray:msgs];
                    if (offset > 0) {
                        [array removeObjectAtIndex:0];
                    }
                    if (more) {
                        [array removeLastObject];
                    }
                    [[IMDatabaseManager sharedInstance]saveHistoryMessages:array];
                    completeBlock(array, more, error);
                }];
            }
        }
    }];
}

+ (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID {
    [[IMDatabaseManager sharedInstance] resetUnreadMessageCountWithTopicID:topicID];
}

+ (IMTopic *)findTopicWithMember:(IMMember *)member {
   return [[IMDatabaseManager sharedInstance] findTopicWithMember:member];
}

+ (NSTimeInterval)obtainTimeoffset {
    return [IMRequestManager sharedInstance].timeoffset;
}

+ (BOOL)topic:(IMTopic *)topic isWithMember:(IMMember *)member {
    if (topic.type != TopicType_Private) {
        return NO;
    }
    for (IMMember *item in topic.members) {
        if (item.memberID == member.memberID) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isSameTopicWithOneTopic:(IMTopic *)topic anotherTopic:(IMTopic *)anotherTopic {
    if (topic.topicID == anotherTopic.topicID) {
        return YES;
    }
    NSMutableArray *topicMembers = [NSMutableArray arrayWithCapacity:topic.members.count];
    NSMutableArray *anotherTopicMembers = [NSMutableArray arrayWithCapacity:anotherTopic.members.count];
    [topic.members enumerateObjectsUsingBlock:^(IMMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [topicMembers addObject:[NSString stringWithFormat:@"%@",@(obj.memberID)]];
    }];
    [anotherTopic.members enumerateObjectsUsingBlock:^(IMMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [anotherTopicMembers addObject:[NSString stringWithFormat:@"%@",@(obj.memberID)]];
    }];
    if (topic.type == anotherTopic.type && topicMembers.count == anotherTopicMembers.count) {
        for (NSString *memberID in topicMembers) {
            if (![anotherTopicMembers containsObject:memberID]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
@end
