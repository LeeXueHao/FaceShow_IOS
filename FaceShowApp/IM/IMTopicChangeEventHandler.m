//
//  IMTopicChangeEventHandler.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTopicChangeEventHandler.h"
#import "TopicGet.pbobjc.h"
#import "IMRequestManager.h"
#import "IMDatabaseManager.h"
#import "IMManager.h"
#import "IMConnectionManager.h"
#import "IMConfig.h"

@implementation IMTopicChangeEventHandler
- (void)handleData:(NSData *)data inTopic:(NSString *)topic {
    NSError *error = nil;
    TopicGet *msg = [TopicGet parseFromData:data error:&error];
    if (error) {
        NSLog(@"parse error:%@",error.localizedDescription);
        return;
    }
    [[IMRequestManager sharedInstance]requestTopicDetailWithTopicIds:[NSString stringWithFormat:@"%@",@(msg.topicId)] completeBlock:^(NSArray<IMTopic *> *topics, NSError *error) {
        for (IMTopic *topic in topics) {
            [[IMDatabaseManager sharedInstance]saveTopic:topic];
            BOOL isIn = NO;
            for (IMMember *member in topic.members) {
                if (member.memberID == [IMManager sharedInstance].currentMember.memberID) {
                    isIn = YES;
                    break;
                }
            }
            if (!isIn) {
                [[IMConnectionManager sharedInstance]unsubscribeTopic:[IMConfig topicForTopicID:topic.topicID]];
                [[IMDatabaseManager sharedInstance]clearTopic:topic];
            }
        }
    }];
}
@end
