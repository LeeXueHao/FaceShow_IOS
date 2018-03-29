//
//  IMOfflineMsgUpdateService.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMOfflineMsgUpdateService.h"
#import "IMRequestManager.h"
#import "IMDatabaseManager.h"

@interface IMOfflineMsgUpdateService()
@property (nonatomic, assign) int64_t topicID;
@property (nonatomic, assign) int64_t startID;
@property (nonatomic, strong) void(^completeBlock)(NSError *error);
@end

@implementation IMOfflineMsgUpdateService
- (instancetype)initWithTopicID:(int64_t)topicID startID:(int64_t)startID {
    if (self = [super init]) {
        self.topicID = topicID;
        self.startID = startID;
    }
    return self;
}

- (void)startWithCompleteBlock:(void(^)(NSError *error))completeBlock {
    self.completeBlock = completeBlock;
    [self start];
}

- (void)start {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestTopicMsgsWithTopicID:self.topicID startID:self.startID asending:YES dataNum:20 completeBlock:^(NSArray<IMTopicMessage *> *msgs, NSError *error) {
        STRONG_SELF
        if (error) {
            self.completeBlock(error);
            return;
        }
        BOOL hasMore = msgs.count==20;
        for (IMTopicMessage *message in msgs) {
            if (message.messageID == self.startID) {
                continue;
            }
            IMTopicMessage *dbMsg = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:message.uniqueID];
            if (dbMsg) {
                hasMore = NO;
                break;
            }
            [[IMDatabaseManager sharedInstance]saveMessage:message];
        }
        if (hasMore) {
            [[IMDatabaseManager sharedInstance]updateOfflineMsgFetchRecordStartIDInTopic:self.topicID from:self.startID to:msgs.lastObject.messageID];
            self.startID = msgs.lastObject.messageID;
            [self start];
        }else {
            [[IMDatabaseManager sharedInstance]removeOfflineMsgFetchRecordInTopic:self.topicID withStartID:self.startID];
            self.completeBlock(nil);
        }
    }];
}

@end
