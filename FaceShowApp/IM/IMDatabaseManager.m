//
//  IMDatabaseManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMDatabaseManager.h"
#import "IMMemberEntity+CoreDataClass.h"
#import "IMTopicEntity+CoreDataClass.h"
#import "IMTopicMessageEntity+CoreDataClass.h"
#import "IMManager.h"

NSString * const kIMMessageDidUpdateNotification = @"kIMMessageDidUpdateNotification";
NSString * const kIMTopicDidUpdateNotification = @"kIMTopicDidUpdateNotification";

NSString * const kIMUnreadMessageCountDidUpdateNotification = @"kIMUnreadMessageCountDidUpdateNotification";
NSString * const kIMUnreadMessageCountTopicKey = @"kIMUnreadMessageCountTopicKey";
NSString * const kIMUnreadMessageCountKey = @"kIMUnreadMessageCountKey";

@implementation IMDatabaseManager
+ (IMDatabaseManager *)sharedInstance {
    static IMDatabaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMDatabaseManager alloc] init];
    });
    return manager;
}

#pragma mark - 保存
- (void)saveMember:(IMMember *)member {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"memberID = %@",@(member.memberID)];
        IMMemberEntity *entity = [IMMemberEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (!entity) {
            entity = [IMMemberEntity MR_createEntityInContext:localContext];
        }
        entity.memberID = member.memberID;
        entity.userID = member.userID;
        entity.name = member.name;
        entity.avatar = member.avatar;
    }];
}

- (void)saveMessage:(IMTopicMessage *)message {
    __block BOOL repeatedMsg = NO;
    __block BOOL unreadMsg = NO;
    __block int64_t topicID = 0;
    __block int64_t unreadCount = 0;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@ && curMember.memberID = %@",message.uniqueID,@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicMessageEntity *entity = [IMTopicMessageEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (entity.sendState == MessageSendState_Success) {
            repeatedMsg = YES;
            return;
        }
        if (!entity) {
            entity = [IMTopicMessageEntity MR_createEntityInContext:localContext];
        }
        entity.channel = message.channel;
        entity.sendState = message.sendState;
        entity.text = message.text;
        entity.thumbnail = message.thumbnail;
        entity.viewUrl = message.viewUrl;
        entity.topicID = message.topicID;
        entity.type = message.type;
        entity.uniqueID = message.uniqueID;
        entity.messageID = message.messageID;
        if (entity.sendTime == 0) {
            entity.sendTime = message.sendTime;
        }
        if (!entity.primaryKey || message.sendState == MessageSendState_Sending) {
            IMTopicMessageEntity *lastEntity = [IMTopicMessageEntity MR_findFirstOrderedByAttribute:@"primaryKey" ascending:NO inContext:localContext];
            entity.primaryKey = lastEntity.primaryKey + 1;
        }
        
        NSPredicate *curMemberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
        IMMemberEntity *curMemberEntity = [IMMemberEntity MR_findFirstWithPredicate:curMemberPredicate inContext:localContext];
        entity.curMember = curMemberEntity;
        
        NSPredicate *senderPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@(message.sender.memberID)];
        IMMemberEntity *senderEntity = [IMMemberEntity MR_findFirstWithPredicate:senderPredicate inContext:localContext];
        entity.sender = senderEntity;
        
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(message.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        topicEntity.latestMessage = entity;
        if (message.sender.memberID != [IMManager sharedInstance].currentMember.memberID) {
            topicEntity.unreadCount += 1;
            unreadMsg = YES;
            topicID = topicEntity.topicID;
            unreadCount = topicEntity.unreadCount;
        }
        
        // 补充message缺少的字段值，保证通知出去的message是完整的
        message.sendTime = entity.sendTime;
        message.index = entity.primaryKey;
        message.sender.userID = senderEntity.userID;
        message.sender.avatar = senderEntity.avatar;
        message.sender.name = senderEntity.name;
        message.sender.memberID = senderEntity.memberID;
    }];
    if (!repeatedMsg) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kIMMessageDidUpdateNotification object:message];
    }
    if (unreadMsg) {
        NSDictionary *info = @{kIMUnreadMessageCountTopicKey:@(topicID),
                               kIMUnreadMessageCountKey:@(unreadCount)};
        [[NSNotificationCenter defaultCenter]postNotificationName:kIMUnreadMessageCountDidUpdateNotification object:nil userInfo:info];
    }
}

- (void)saveTopic:(IMTopic *)topic {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topic.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        if (!topicEntity) {
            topicEntity = [IMTopicEntity MR_createEntityInContext:localContext];
        }
        topicEntity.name = topic.name;
        topicEntity.group = topic.group;
        topicEntity.channel = topic.channel;
        topicEntity.topicID = topic.topicID;
        topicEntity.type = topic.type;
        topicEntity.topicChange = topic.topicChange;
        topicEntity.latestMsgId = topic.latestMsgId;
        
        NSPredicate *curMemberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
        IMMemberEntity *curMemberEntity = [IMMemberEntity MR_findFirstWithPredicate:curMemberPredicate inContext:localContext];
        topicEntity.curMember = curMemberEntity;
        
        NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topic.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:msgPredicate sortedBy:@"primaryKey" ascending:NO inContext:localContext];
        topicEntity.latestMessage = msgEntity;
        
        if (topic.members.count > 0) {
            NSMutableArray *memberIDArray = [NSMutableArray array];
            for (IMMember *member in topic.members) {
                NSPredicate *memberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@(member.memberID)];
                IMMemberEntity *memberEntity = [IMMemberEntity MR_findFirstWithPredicate:memberPredicate inContext:localContext];
                if (!memberEntity) {
                    memberEntity = [IMMemberEntity MR_createEntityInContext:localContext];
                }
                memberEntity.memberID = member.memberID;
                memberEntity.userID = member.userID;
                memberEntity.name = member.name;
                memberEntity.avatar = member.avatar;
                
                [memberIDArray addObject:[NSString stringWithFormat:@"%@",@(member.memberID)]];
            }
            topicEntity.memberIDs = [memberIDArray componentsJoinedByString:@","];
        }
        
        // 补充topic缺少的latest message信息
        topic.latestMessage = [self messageFromEntity:msgEntity];
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:kIMTopicDidUpdateNotification object:topic];
}

- (void)clearDirtyMessages {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = 0"];
        [IMTopicMessageEntity MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    }];
}

- (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        topicEntity.unreadCount = 0;
    }];
}
#pragma mark - 查询
- (NSArray<IMTopic *> *)findAllTopics {
    NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
    NSArray *topics = [IMTopicEntity MR_findAllWithPredicate:topicPredicate];
    NSMutableArray *array = [NSMutableArray array];
    for (IMTopicEntity *entity in topics) {
        [array addObject:[self topicFromEntity:entity]];
    }
    return array;
}

- (IMTopic *)findTopicWithID:(int64_t)topicID {
    NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@ && topicID = %@",@([IMManager sharedInstance].currentMember.memberID),@(topicID)];
    IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate];
    return [self topicFromEntity:topicEntity];
}

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID)];
    NSFetchRequest *request = [IMTopicMessageEntity MR_requestAllSortedBy:@"primaryKey" ascending:asending withPredicate:predicate];
    [request setFetchLimit:count+1];
    NSArray *results = [IMTopicMessageEntity MR_executeFetchRequest:request];
    NSMutableArray *array = [NSMutableArray array];
    for (IMTopicMessageEntity *entity in results) {
        IMTopicMessage *message = [self messageFromEntity:entity];
        [array addObject:message];
    }
    BOOL hasMore = NO;
    if (array.count > count) {
        [array removeLastObject];
        hasMore = YES;
    }
    BLOCK_EXEC(completeBlock,array,hasMore);
}

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                beforeIndex:(int64_t)index
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@ && primaryKey < %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID),@(index)];
    NSFetchRequest *request = [IMTopicMessageEntity MR_requestAllSortedBy:@"primaryKey" ascending:NO withPredicate:predicate];
    [request setFetchLimit:count+1];
    NSArray *results = [IMTopicMessageEntity MR_executeFetchRequest:request];
    NSMutableArray *array = [NSMutableArray array];
    for (IMTopicMessageEntity *entity in results) {
        IMTopicMessage *message = [self messageFromEntity:entity];
        [array addObject:message];
    }
    BOOL hasMore = NO;
    if (array.count > count) {
        [array removeLastObject];
        hasMore = YES;
    }
    BLOCK_EXEC(completeBlock,array,hasMore);
}

- (IMTopicMessage *)findMessageWithUniqueID:(NSString *)uniqueID {
    NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@ && uniqueID = %@",@([IMManager sharedInstance].currentMember.memberID),uniqueID];
    IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:msgPredicate];
    return [self messageFromEntity:msgEntity];
}

- (IMTopicMessage *)findLastSuccessfulMessageInTopic:(int64_t)topicID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@ && sendState = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID),@(MessageSendState_Success)];
    IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:predicate sortedBy:@"messageID" ascending:NO];
    return [self messageFromEntity:msgEntity];
}

#pragma mark - 转换
- (IMTopic *)topicFromEntity:(IMTopicEntity *)entity {
    if (!entity) {
        return nil;
    }
    IMTopic *topic = [[IMTopic alloc]init];
    topic.type = entity.type;
    topic.topicID = entity.topicID;
    topic.name = entity.name;
    topic.group = entity.group;
    topic.channel = entity.channel;
    topic.topicChange = entity.topicChange;
    topic.latestMsgId = entity.latestMsgId;
    topic.unreadCount = entity.unreadCount;
    topic.latestMessage = [self messageFromEntity:entity.latestMessage];
    
    NSArray *memberIDArray = [entity.memberIDs componentsSeparatedByString:@","];
    NSMutableArray *conditionArray = [NSMutableArray array];
    for (NSString *memberID in memberIDArray) {
        [conditionArray addObject:@(memberID.longLongValue)];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"memberID IN (%@)",conditionArray];
    NSArray *memberEntities = [IMMemberEntity MR_findAllWithPredicate:predicate];    
    NSMutableArray *members = [NSMutableArray array];
    for (IMMemberEntity *member in memberEntities) {
        [members addObject:[self memberFromEntity:member]];
    }
    topic.members = members;
    return topic;
}

- (IMTopicMessage *)messageFromEntity:(IMTopicMessageEntity *)entity {
    if (!entity) {
        return nil;
    }
    IMTopicMessage *message = [[IMTopicMessage alloc]init];
    message.type = entity.type;
    message.sendTime = entity.sendTime;
    message.text = entity.text;
    message.thumbnail = entity.thumbnail;
    message.viewUrl = entity.viewUrl;
    message.sendState = entity.sendState;
    message.index = entity.primaryKey;
    message.topicID = entity.topicID;
    message.channel = entity.channel;
    message.uniqueID = entity.uniqueID;
    message.messageID = entity.messageID;
    message.sender = [self memberFromEntity:entity.sender];
    return message;
}

- (IMMember *)memberFromEntity:(IMMemberEntity *)entity {
    if (!entity) {
        return nil;
    }
    IMMember *member = [[IMMember alloc]init];
    member.memberID = entity.memberID;
    member.userID = entity.userID;
    member.name = entity.name;
    member.avatar = entity.avatar;
    return member;
}

- (IMTopic *)findTopicWithMember:(IMMember *)member {
    NSArray *topicArray = [self findAllTopics];
    for (IMTopic *topic in topicArray) {
        if (topic.type == TopicType_Private) {
            for (IMMember *targetMember in topic.members) {
#warning 此处比较两个menmber为同一个的决定属性 需要看通讯录的数据结构再确定
                if (member.memberID && targetMember.memberID == member.memberID) {
                    return topic;
                }
                if (targetMember.userID == member.userID) {
                    return topic;
                }
            }
        }
    }
    return nil;
}
@end
