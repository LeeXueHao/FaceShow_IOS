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

@implementation IMNewTopicEventHandler
- (void)handleData:(NSData *)data inTopic:(NSString *)topic {
    NSError *error = nil;
    TopicGet *msg = [TopicGet parseFromData:data error:&error];
    if (error) {
        NSLog(@"parse error:%@",error.localizedDescription);
        return;
    }
    [[IMRequestManager sharedInstance]requestTopicDetailWithTopicIds:[NSString stringWithFormat:@"%@",@(msg.topicId)] completeBlock:^(NSArray<IMTopic *> *topics, NSError *error) {
        if (error) {
            return;
        }
        for (IMTopic *topic in topics) {
            [[IMDatabaseManager sharedInstance]saveTopic:topic];
        }
        [[IMConnectionManager sharedInstance]subscribeTopic:[IMConfig topicForTopicID:msg.topicId]];
    }];
}
@end
