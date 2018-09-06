//
//  IMNewTopicEventHandler.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMNewTopicEventHandler.h"
#import "TopicGet.pbobjc.h"
#import "IMRequestManager.h"
#import "IMConnectionManager.h"
#import "IMConfig.h"
#import "IMDatabaseManager.h"
#import "IMHistoryMessageFetcher.h"
#import "IMTopicUpdateService.h"

@implementation IMNewTopicEventHandler
- (void)handleData:(NSData *)data inTopic:(NSString *)topic {
    NSError *error = nil;
    TopicGet *msg = [TopicGet parseFromData:data error:&error];
    if (error) {
        NSLog(@"parse error:%@",error.localizedDescription);
        return;
    }
    IMTopic *dbTopic = [[IMDatabaseManager sharedInstance]findTopicWithID:msg.topicId];
    if (!dbTopic) {
        IMTopic *imtopic = [[IMTopic alloc]init];
        imtopic.topicID = msg.topicId;
        [[IMDatabaseManager sharedInstance]saveTopic:imtopic];
        [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:msg.topicId]];
        
        IMHistoryFetchRecord *record = [[IMHistoryFetchRecord alloc]init];
        record.topic = imtopic;
        record.count = 15;
        [[IMHistoryMessageFetcher sharedInstance]addRecord:record];
        
        [[IMTopicUpdateService sharedInstance] addTopic:imtopic withCompleteBlock:nil];
    }
    
    [[IMTopicUpdateService sharedInstance] addTopic:dbTopic withCompleteBlock:nil];
}
@end
