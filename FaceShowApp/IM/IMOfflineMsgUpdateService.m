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
@end

@implementation IMOfflineMsgUpdateService
- (instancetype)initWithTopicID:(int64_t)topicID startID:(int64_t)startID {
    if (self = [super init]) {
        self.topicID = topicID;
        self.startID = startID;
    }
    return self;
}

- (void)start {
    WEAK_SELF
    [[IMRequestManager sharedInstance]requestTopicMsgsWithTopicID:self.topicID startID:self.startID asending:YES completeBlock:^(NSArray<IMTopicMessage *> *msgs, NSError *error) {
        STRONG_SELF
        BOOL hasMore = msgs.count>0;
        for (IMTopicMessage *message in msgs) {
            IMTopicMessage *dbMsg = [[IMDatabaseManager sharedInstance]findMessageWithUniqueID:message.uniqueID];
            if (dbMsg) {
                hasMore = NO;
                break;
            }
            [[IMDatabaseManager sharedInstance]saveMessage:message];
        }
        if (hasMore) {
            self.startID = msgs.lastObject.messageID;
            [self start];
        }
    }];
}
@end
