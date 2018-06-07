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
#import "IMTopicOfflineMsgFetchEntity+CoreDataClass.h"
#import "IMManager.h"

NSString * const kIMMessageDidUpdateNotification = @"kIMMessageDidUpdateNotification";
NSString * const kIMTopicDidUpdateNotification = @"kIMTopicDidUpdateNotification";

NSString * const kIMUnreadMessageCountDidUpdateNotification = @"kIMUnreadMessageCountDidUpdateNotification";
NSString * const kIMUnreadMessageCountTopicKey = @"kIMUnreadMessageCountTopicKey";
NSString * const kIMUnreadMessageCountKey = @"kIMUnreadMessageCountKey";

NSString * const kIMTopicInfoUpdateNotification = @"kIMTopicInfoUpdateNotification";

NSString * const kIMTopicDidRemoveNotification = @"kIMTopicDidRemoveNotification";

@interface IMDatabaseManager ()
@property (nonatomic, strong) dispatch_queue_t operationQueue;
@end

@implementation IMDatabaseManager
+ (IMDatabaseManager *)sharedInstance {
    static IMDatabaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMDatabaseManager alloc] init];
        manager.operationQueue = dispatch_queue_create("im_operation_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return manager;
}

#pragma mark - 保存
- (void)saveMember:(IMMember *)member {
    dispatch_barrier_async(self.operationQueue, ^{
        [self saveMemberInQueue:member];
    });
}

- (void)saveMemberInQueue:(IMMember *)member {
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
    [self saveMessages:@[message]];
}

- (void)saveMessages:(NSArray<IMTopicMessage *> *)messages {
    dispatch_barrier_async(self.operationQueue, ^{
        [self saveMessagesInQueue:messages];
    });
}

- (void)saveMessagesInQueue:(NSArray<IMTopicMessage *> *)messages {
    NSMutableArray *savedMsgArray = [NSMutableArray array];
    __block BOOL unreadMsg = NO;
    __block int64_t topicID = 0;
    __block int64_t unreadCount = 0;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSMutableArray *array = [NSMutableArray array];
        for (IMTopicMessage *item in messages) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@ && curMember.memberID = %@",item.uniqueID,@([IMManager sharedInstance].currentMember.memberID)];
            IMTopicMessageEntity *entity = [IMTopicMessageEntity MR_findFirstWithPredicate:predicate inContext:localContext];
            if (entity.sendState == MessageSendState_Success) {
                continue;
            }
            [array addObject:item];
        }
        for (IMTopicMessage *message in array) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@ && curMember.memberID = %@",message.uniqueID,@([IMManager sharedInstance].currentMember.memberID)];
            IMTopicMessageEntity *entity = [IMTopicMessageEntity MR_findFirstWithPredicate:predicate inContext:localContext];
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
            entity.width = message.width;
            entity.height = message.height;
            if (entity.sendTime == 0) {
                entity.sendTime = message.sendTime;
            }
            if (!entity.primaryKey) {
                IMTopicMessageEntity *lastEntity = [IMTopicMessageEntity MR_findFirstOrderedByAttribute:@"primaryKey" ascending:NO inContext:localContext];
                entity.primaryKey = lastEntity.primaryKey + 1;
            }
            
            NSPredicate *curMemberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
            IMMemberEntity *curMemberEntity = [IMMemberEntity MR_findFirstWithPredicate:curMemberPredicate inContext:localContext];
            entity.curMember = curMemberEntity;
            
            NSPredicate *senderPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@(message.sender.memberID)];
            IMMemberEntity *senderEntity = [IMMemberEntity MR_findFirstWithPredicate:senderPredicate inContext:localContext];
            if (!senderEntity) {
                senderEntity = [IMMemberEntity MR_createEntityInContext:localContext];
                senderEntity.name = message.sender.name;
                senderEntity.avatar = message.sender.avatar;
                senderEntity.memberID = message.sender.memberID;
                senderEntity.userID = message.sender.userID;
            }
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
            
            [savedMsgArray addObject:[self messageFromEntity:entity]];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (savedMsgArray.count > 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kIMMessageDidUpdateNotification object:savedMsgArray];
        }
        if (unreadMsg) {
            NSDictionary *info = @{kIMUnreadMessageCountTopicKey:@(topicID),
                                   kIMUnreadMessageCountKey:@(unreadCount)};
            [[NSNotificationCenter defaultCenter]postNotificationName:kIMUnreadMessageCountDidUpdateNotification object:nil userInfo:info];
        }
    });
}

- (void)saveHistoryMessages:(NSArray<IMTopicMessage *> *)messages
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *savedMsgs))completeBlock {
    dispatch_barrier_async(self.operationQueue, ^{
        [self saveHistoryMessagesInQueue:messages completeBlock:completeBlock];
    });
}

- (void)saveHistoryMessagesInQueue:(NSArray<IMTopicMessage *> *)messages
                     completeBlock:(void(^)(NSArray<IMTopicMessage *> *savedMsgs))completeBlock{
    __block BOOL unreadMsg = NO;
    __block int64_t topicID = 0;
    __block int64_t unreadCount = 0;
    NSMutableArray<IMTopicMessage *> *dbMsgArray = [NSMutableArray array];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSMutableArray<IMTopicMessage *> *array = [NSMutableArray array];
        for (IMTopicMessage *msg in messages) {
            NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && uniqueID = %@ && curMember.memberID = %@",@(msg.topicID),msg.uniqueID,@([IMManager sharedInstance].currentMember.memberID)];
            IMTopicMessageEntity *entity = [IMTopicMessageEntity MR_findFirstWithPredicate:searchPredicate inContext:localContext];
            if (!entity) {
                [array addObject:msg];
            }
        }
        if (array.count == 0) {
            return;
        }
        NSPredicate *curMemberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
        IMMemberEntity *curMemberEntity = [IMMemberEntity MR_findFirstWithPredicate:curMemberPredicate inContext:localContext];
        
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(array.firstObject.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(array.firstObject.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        NSArray *localMsgs = [IMTopicMessageEntity MR_findAllWithPredicate:predicate inContext:localContext];
        for (IMTopicMessageEntity *msg in localMsgs) {
            msg.primaryKey += array.count;
        }
        int64_t key = array.count;
        for (IMTopicMessage *message in array) {
            IMTopicMessageEntity *entity = [IMTopicMessageEntity MR_createEntityInContext:localContext];
            entity.channel = message.channel;
            entity.sendState = message.sendState;
            entity.text = message.text;
            entity.thumbnail = message.thumbnail;
            entity.viewUrl = message.viewUrl;
            entity.topicID = message.topicID;
            entity.type = message.type;
            entity.uniqueID = message.uniqueID;
            entity.messageID = message.messageID;
            entity.width = message.width;
            entity.height = message.height;
            entity.sendTime = message.sendTime;
            entity.primaryKey = key--;
            entity.curMember = curMemberEntity;
            
            NSPredicate *senderPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@(message.sender.memberID)];
            IMMemberEntity *senderEntity = [IMMemberEntity MR_findFirstWithPredicate:senderPredicate inContext:localContext];
            if (!senderEntity) {
                senderEntity = [IMMemberEntity MR_createEntityInContext:localContext];
                senderEntity.name = message.sender.name;
                senderEntity.avatar = message.sender.avatar;
                senderEntity.memberID = message.sender.memberID;
                senderEntity.userID = message.sender.userID;
            }
            entity.sender = senderEntity;
            
            if ([array indexOfObject:message] == 0) {
                if (!topicEntity.latestMessage) {
                    topicEntity.latestMessage = entity;
                }
            }
            [dbMsgArray addObject:[self messageFromEntity:entity]];
        }
        
        if (localMsgs.count == 0) {
            for (IMTopicMessage *message in array) {
                if (message.sender.memberID != [IMManager sharedInstance].currentMember.memberID) {
                    topicEntity.unreadCount += 1;
                    unreadMsg = YES;
                    topicID = topicEntity.topicID;
                    unreadCount = topicEntity.unreadCount;
                }
            }
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unreadMsg) {
            NSDictionary *info = @{kIMUnreadMessageCountTopicKey:@(topicID),
                                   kIMUnreadMessageCountKey:@(unreadCount)};
            [[NSNotificationCenter defaultCenter]postNotificationName:kIMUnreadMessageCountDidUpdateNotification object:nil userInfo:info];
        }
        completeBlock(dbMsgArray);
    });
}

- (void)saveTopic:(IMTopic *)topic {
    dispatch_barrier_async(self.operationQueue, ^{
        [self saveTopicInQueue:topic];
    });
}

- (void)saveTopicInQueue:(IMTopic *)topic {
    __block IMTopic *dbTopic = nil;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topic.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        if (!topicEntity) {
            topicEntity = [IMTopicEntity MR_createEntityInContext:localContext];
        }
        topicEntity.name = topic.name;
        topicEntity.group = topic.group;
        topicEntity.groupID = topic.groupID;
        topicEntity.channel = topic.channel;
        topicEntity.topicID = topic.topicID;
        topicEntity.type = topic.type;
        topicEntity.topicChange = topic.topicChange;
        topicEntity.latestMsgId = topic.latestMsgId;
        
        NSPredicate *curMemberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
        IMMemberEntity *curMemberEntity = [IMMemberEntity MR_findFirstWithPredicate:curMemberPredicate inContext:localContext];
        topicEntity.curMember = curMemberEntity;
        
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
            
            [self migrateTempMessagesIfNeededToTopicEntity:topicEntity inContext:localContext];
        }
        
        NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topic.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:msgPredicate sortedBy:@"primaryKey" ascending:NO inContext:localContext];
        topicEntity.latestMessage = msgEntity;
        
        dbTopic = [self topicFromEntity:topicEntity inContext:localContext];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kIMTopicDidUpdateNotification object:dbTopic];
    });
}

- (void)migrateTempMessagesIfNeededToTopicEntity:(IMTopicEntity *)topicEntity inContext:(NSManagedObjectContext *)context {
    if (topicEntity.topicID < 0) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID < 0 && curMember.memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
    NSArray *tempEntities = [IMTopicEntity MR_findAllWithPredicate:predicate inContext:context];
    for (IMTopicEntity *entity in tempEntities) {
        if ([self isSameTopicWithOneEntity:entity anotherEntity:topicEntity]) {
            NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(entity.topicID),@([IMManager sharedInstance].currentMember.memberID)];
            NSArray *msgEntities = [IMTopicMessageEntity MR_findAllWithPredicate:msgPredicate inContext:context];
            for (IMTopicMessageEntity *msg in msgEntities) {
                msg.topicID = topicEntity.topicID;
            }
            [entity MR_deleteEntityInContext:context];
            return;
        }
    }
}

- (BOOL)isSameTopicWithOneEntity:(IMTopicEntity *)entity anotherEntity:(IMTopicEntity *)anotherEntity {
    if (entity.topicID == anotherEntity.topicID) {
        return YES;
    }
    NSArray *entityMemberIDs = [entity.memberIDs componentsSeparatedByString:@","];
    NSArray *anotherEntityMemberIDs = [anotherEntity.memberIDs componentsSeparatedByString:@","];
    if (entity.type == anotherEntity.type && entityMemberIDs.count == anotherEntityMemberIDs.count) {
        for (NSString *memberID in entityMemberIDs) {
            if (![anotherEntityMemberIDs containsObject:memberID]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (void)updateTopicInfo:(IMTopic *)topic {
    dispatch_barrier_async(self.operationQueue, ^{
        [self updateTopicInfoInQueue:topic];
    });
}

- (void)updateTopicInfoInQueue:(IMTopic *)topic {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topic.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        if (!topicEntity) {
            return;
        }
        topicEntity.name = topic.name;
        topicEntity.group = topic.group;
        
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
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kIMTopicInfoUpdateNotification object:topic];
    });
}

- (void)clearTopic:(IMTopic *)topic {
    dispatch_barrier_async(self.operationQueue, ^{
        [self clearTopicInQueue:topic];
    });
}

- (void)clearTopicInQueue:(IMTopic *)topic {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topic.topicID),@([IMManager sharedInstance].currentMember.memberID)];
        [IMTopicEntity MR_deleteAllMatchingPredicate:topicPredicate inContext:localContext];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kIMTopicDidRemoveNotification object:topic];
    });
}

- (void)resetUnreadMessageCountWithTopicID:(int64_t)topicID {
    dispatch_barrier_async(self.operationQueue, ^{
        [self resetUnreadMessageCountInQueueWithTopicID:topicID];
    });
}

- (void)resetUnreadMessageCountInQueueWithTopicID:(int64_t)topicID {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:localContext];
        topicEntity.unreadCount = 0;
    }];
}

- (int64_t)generateTempTopicID {
    __block int64_t topicID = -1;
    dispatch_sync(self.operationQueue, ^{
        topicID = [self generateTempTopicIDInQueue];
    });
    return topicID;
}

- (int64_t)generateTempTopicIDInQueue {
    NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"topicID < 0 && curMember.memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate sortedBy:@"topicID" ascending:YES inContext:context];
    __block int64_t tempID = -1;
    [context performBlockAndWait:^{
        if (topicEntity) {
            tempID = topicEntity.topicID - 1;
        }
    }];
    return tempID;
}

- (BOOL)isTempTopicID:(int64_t)topicID {
    return topicID < 0;
}

- (void)markAllUncompleteMessagesFailed {
    dispatch_barrier_async(self.operationQueue, ^{
        [self markAllUncompleteMessagesFailedInQueue];
    });
}

- (void)markAllUncompleteMessagesFailedInQueue {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@ && sendState = %@",@([IMManager sharedInstance].currentMember.memberID),@(MessageSendState_Sending)];
        NSArray *msgs = [IMTopicMessageEntity MR_findAllWithPredicate:predicate inContext:localContext];
        for (IMTopicMessageEntity *entity in msgs) {
            entity.sendState = MessageSendState_Failed;
        }
    }];
}

#pragma mark - 查询
- (NSArray<IMTopic *> *)findAllTopics {
    __block NSArray *topics;
    dispatch_sync(self.operationQueue, ^{
        topics = [self findAllTopicsInQueue];
    });
    return topics;
}

- (NSArray<IMTopic *> *)findAllTopicsInQueue {
    NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
    NSMutableArray *array = [NSMutableArray array];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    NSArray *topics = [IMTopicEntity MR_findAllWithPredicate:topicPredicate inContext:context];
    [context performBlockAndWait:^{
        for (IMTopicEntity *entity in topics) {
            [array addObject:[self topicFromEntity:entity inContext:context]];
        }
    }];
    
    return array;
}

- (IMTopic *)findTopicWithID:(int64_t)topicID {
    __block IMTopic *topic;
    dispatch_sync(self.operationQueue, ^{
        topic = [self findTopicInQueueWithID:topicID];
    });
    return topic;
}

- (IMTopic *)findTopicInQueueWithID:(int64_t)topicID {
    NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@ && topicID = %@",@([IMManager sharedInstance].currentMember.memberID),@(topicID)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    IMTopicEntity *topicEntity = [IMTopicEntity MR_findFirstWithPredicate:topicPredicate inContext:context];
    __block IMTopic *topic = nil;
    [context performBlockAndWait:^{
        topic = [self topicFromEntity:topicEntity inContext:context];
    }];
    return topic;
}

- (void)findMessagesInTopic:(int64_t)topicID
                      count:(NSUInteger)count
                   asending:(BOOL)asending
              completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    __block NSArray *msgArray;
    __block BOOL more;
    dispatch_sync(self.operationQueue, ^{
        [self findMessagesInQueueInTopic:topicID count:count asending:asending completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
            msgArray = array;
            more = hasMore;
        }];
    });
    BLOCK_EXEC(completeBlock, msgArray, more);
}

- (void)findMessagesInQueueInTopic:(int64_t)topicID
                             count:(NSUInteger)count
                          asending:(BOOL)asending
                     completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    NSFetchRequest *request = [IMTopicMessageEntity MR_requestAllSortedBy:@"primaryKey" ascending:asending withPredicate:predicate inContext:context];
    [request setFetchLimit:count+1];
    NSArray *results = [IMTopicMessageEntity MR_executeFetchRequest:request inContext:context];
    NSMutableArray *array = [NSMutableArray array];
    [context performBlockAndWait:^{
        for (IMTopicMessageEntity *entity in results) {
            IMTopicMessage *message = [self messageFromEntity:entity];
            [array addObject:message];
        }
    }];
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
    __block NSArray *msgArray;
    __block BOOL more;
    dispatch_sync(self.operationQueue, ^{
        [self findMessagesInQueueInTopic:topicID count:count beforeIndex:index completeBlock:^(NSArray<IMTopicMessage *> *array, BOOL hasMore) {
            msgArray = array;
            more = hasMore;
        }];
    });
    BLOCK_EXEC(completeBlock, msgArray, more);
}

- (void)findMessagesInQueueInTopic:(int64_t)topicID
                             count:(NSUInteger)count
                       beforeIndex:(int64_t)index
                     completeBlock:(void(^)(NSArray<IMTopicMessage *> *array, BOOL hasMore))completeBlock {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@ && primaryKey < %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID),@(index)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    NSFetchRequest *request = [IMTopicMessageEntity MR_requestAllSortedBy:@"primaryKey" ascending:NO withPredicate:predicate inContext:context];
    [request setFetchLimit:count+1];
    NSArray *results = [IMTopicMessageEntity MR_executeFetchRequest:request inContext:context];
    NSMutableArray *array = [NSMutableArray array];
    [context performBlockAndWait:^{
        for (IMTopicMessageEntity *entity in results) {
            IMTopicMessage *message = [self messageFromEntity:entity];
            [array addObject:message];
        }
    }];
    BOOL hasMore = NO;
    if (array.count > count) {
        [array removeLastObject];
        hasMore = YES;
    }
    BLOCK_EXEC(completeBlock,array,hasMore);
}

- (IMTopicMessage *)findMessageWithUniqueID:(NSString *)uniqueID {
    __block IMTopicMessage *message;
    dispatch_sync(self.operationQueue, ^{
        message = [self findMessageInQueueWithUniqueID:uniqueID];
    });
    return message;
}

- (IMTopicMessage *)findMessageInQueueWithUniqueID:(NSString *)uniqueID {
    NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"curMember.memberID = %@ && uniqueID = %@",@([IMManager sharedInstance].currentMember.memberID),uniqueID];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:msgPredicate inContext:context];
    __block IMTopicMessage *message = nil;
    [context performBlockAndWait:^{
        message = [self messageFromEntity:msgEntity];
    }];
    return message;
}

- (IMTopicMessage *)findLastSuccessfulMessageInTopic:(int64_t)topicID {
    __block IMTopicMessage *message;
    dispatch_sync(self.operationQueue, ^{
        message = [self findLastSuccessfulMessageInQueueInTopic:topicID];
    });
    return message;
}

- (IMTopicMessage *)findLastSuccessfulMessageInQueueInTopic:(int64_t)topicID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@ && sendState = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID),@(MessageSendState_Success)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:predicate sortedBy:@"messageID" ascending:NO inContext:context];
    __block IMTopicMessage *message = nil;
    [context performBlockAndWait:^{
        message = [self messageFromEntity:msgEntity];
    }];
    return message;
}

- (IMTopicMessage *)findFirstSuccessfulMessageInTopic:(int64_t)topicID {
    __block IMTopicMessage *message;
    dispatch_sync(self.operationQueue, ^{
        message = [self findFirstSuccessfulMessageInQueueInTopic:topicID];
    });
    return message;
}

- (IMTopicMessage *)findFirstSuccessfulMessageInQueueInTopic:(int64_t)topicID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@ && sendState = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID),@(MessageSendState_Success)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    IMTopicMessageEntity *msgEntity = [IMTopicMessageEntity MR_findFirstWithPredicate:predicate sortedBy:@"messageID" ascending:YES inContext:context];
    __block IMTopicMessage *message = nil;
    [context performBlockAndWait:^{
        message = [self messageFromEntity:msgEntity];
    }];
    return message;
}

- (IMTopic *)findTopicWithMember:(IMMember *)member {
    __block IMTopic *topic;
    dispatch_sync(self.operationQueue, ^{
        topic = [self findTopicInQueueWithMember:member];
    });
    return topic;
}

- (IMTopic *)findTopicInQueueWithMember:(IMMember *)member {
    NSArray *topicArray = [self findAllTopics];
    for (IMTopic *topic in topicArray) {
        if (topic.type == TopicType_Private) {
            for (IMMember *targetMember in topic.members) {
                if (member.memberID && targetMember.memberID == member.memberID) {
                    return topic;
                }
            }
        }
    }
    return nil;
}

- (NSArray<IMTopicMessage *> *)findAllFailedMessages {
    __block NSArray *array;
    dispatch_sync(self.operationQueue, ^{
        array = [self findAllFailedMessagesInQueue];
    });
    return array;
}

- (NSArray<IMTopicMessage *> *)findAllFailedMessagesInQueue {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sender.memberID = %@ && sendState = %@",@([IMManager sharedInstance].currentMember.memberID),@(MessageSendState_Failed)];
    NSFetchedResultsController *controller = [IMTopicMessageEntity MR_fetchAllGroupedBy:@"topicID" withPredicate:predicate sortedBy:@"primaryKey" ascending:YES];
    NSMutableArray *array = [NSMutableArray array];
    for (id<NSFetchedResultsSectionInfo> section in controller.sections) {
        for (IMTopicMessageEntity *entity in section.objects) {
            [array addObject:[self messageFromEntity:entity]];
        }
    }
    return array;
}

#pragma mark - 转换
- (IMTopic *)topicFromEntity:(IMTopicEntity *)entity inContext:(NSManagedObjectContext *)context {
    if (!entity) {
        return nil;
    }
    IMTopic *topic = [[IMTopic alloc]init];
    topic.type = entity.type;
    topic.topicID = entity.topicID;
    topic.name = entity.name;
    topic.group = entity.group;
    topic.groupID = entity.groupID;
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
    NSArray *memberEntities = [IMMemberEntity MR_findAllWithPredicate:predicate inContext:context];
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
    message.width = entity.width;
    message.height = entity.height;
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

#pragma mark - 离线消息待抓取记录
- (NSArray<IMTopicOfflineMsgFetchRecord *> *)findAllOfflineMsgFetchRecordsWithTopicID:(int64_t)topicID  {
    __block NSArray *array;
    dispatch_sync(self.operationQueue, ^{
        array = [self findAllOfflineMsgFetchRecordsInQueueWithTopicID:topicID];
    });
    return array;
}

- (NSArray<IMTopicOfflineMsgFetchRecord *> *)findAllOfflineMsgFetchRecordsInQueueWithTopicID:(int64_t)topicID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && curMember.memberID = %@",@(topicID),@([IMManager sharedInstance].currentMember.memberID)];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    NSArray *entities = [IMTopicOfflineMsgFetchEntity MR_findAllSortedBy:@"startID" ascending:YES withPredicate:predicate inContext:context];
    NSMutableArray *array = [NSMutableArray array];
    [context performBlockAndWait:^{
        for (IMTopicOfflineMsgFetchEntity *entity in entities) {
            [array addObject:[self offlineMsgFetchRecordFromEntity:entity]];
        }
    }];
    return array;
}

- (IMTopicOfflineMsgFetchRecord *)offlineMsgFetchRecordFromEntity:(IMTopicOfflineMsgFetchEntity *)entity {
    if (!entity) {
        return nil;
    }
    IMTopicOfflineMsgFetchRecord *record = [[IMTopicOfflineMsgFetchRecord alloc]init];
    record.topicID = entity.topicID;
    record.startID = entity.startID;
    return record;
}

- (void)saveOfflineMsgFetchRecord:(IMTopicOfflineMsgFetchRecord *)record {
    dispatch_barrier_async(self.operationQueue, ^{
        [self saveOfflineMsgFetchRecordInQueue:record];
    });
}

- (void)saveOfflineMsgFetchRecordInQueue:(IMTopicOfflineMsgFetchRecord *)record {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && startID = %@ && curMember.memberID = %@",@(record.topicID),@(record.startID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicOfflineMsgFetchEntity *entity = [IMTopicOfflineMsgFetchEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        if (entity) {
            return;
        }
        entity = [IMTopicOfflineMsgFetchEntity MR_createEntityInContext:localContext];
        entity.topicID = record.topicID;
        entity.startID = record.startID;
        
        NSPredicate *curMemberPredicate = [NSPredicate predicateWithFormat:@"memberID = %@",@([IMManager sharedInstance].currentMember.memberID)];
        IMMemberEntity *curMemberEntity = [IMMemberEntity MR_findFirstWithPredicate:curMemberPredicate inContext:localContext];
        entity.curMember = curMemberEntity;
    }];
}

- (void)updateOfflineMsgFetchRecordStartIDInTopic:(int64_t)topicID from:(int64_t)from to:(int64_t)to {
    dispatch_barrier_async(self.operationQueue, ^{
        [self updateOfflineMsgFetchRecordStartIDInQueueInTopic:topicID from:from to:to];
    });
}
- (void)updateOfflineMsgFetchRecordStartIDInQueueInTopic:(int64_t)topicID from:(int64_t)from to:(int64_t)to {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && startID = %@ && curMember.memberID = %@",@(topicID),@(from),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicOfflineMsgFetchEntity *entity = [IMTopicOfflineMsgFetchEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        entity.topicID = topicID;
        entity.startID = to;
    }];
}

- (void)removeOfflineMsgFetchRecordInTopic:(int64_t)topicID withStartID:(int64_t)startID {
    dispatch_barrier_async(self.operationQueue, ^{
        [self removeOfflineMsgFetchRecordInQueueInTopic:topicID withStartID:startID];
    });
}

- (void)removeOfflineMsgFetchRecordInQueueInTopic:(int64_t)topicID withStartID:(int64_t)startID {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && startID = %@ && curMember.memberID = %@",@(topicID),@(startID),@([IMManager sharedInstance].currentMember.memberID)];
        IMTopicOfflineMsgFetchEntity *entity = [IMTopicOfflineMsgFetchEntity MR_findFirstWithPredicate:predicate inContext:localContext];
        [entity MR_deleteEntityInContext:localContext];
    }];
}

@end

