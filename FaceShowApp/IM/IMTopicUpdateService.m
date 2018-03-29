//
//  IMTopicUpdateService.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTopicUpdateService.h"
#import "IMRequestManager.h"
#import "IMDatabaseManager.h"

@interface IMTopicUpdateService()
@property (nonatomic, strong) NSMutableArray<IMTopic *> *topicArray;
@property (nonatomic, assign) BOOL isTopicUpdating;
@end

@implementation IMTopicUpdateService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.topicArray = [NSMutableArray array];
        self.isTopicUpdating = NO;
    }
    return self;
}

- (void)addTopic:(IMTopic *)topic {
    [self.topicArray addObject:topic];
    [self checkAndUpdate];
}

- (void)checkAndUpdate{
    if (!self.isTopicUpdating && self.topicArray.count>0) {
        self.isTopicUpdating = YES;
        IMTopic *topic = [self.topicArray firstObject];
        WEAK_SELF
        [[IMRequestManager sharedInstance]requestTopicDetailWithTopicIds:[NSString stringWithFormat:@"%@",@(topic.topicID)] completeBlock:^(NSArray<IMTopic *> *topics, NSError *error) {
            STRONG_SELF
            for (IMTopic *topic in topics) {
                [[IMDatabaseManager sharedInstance]saveTopic:topic];
            }
            [self.topicArray removeObjectAtIndex:0];
            self.isTopicUpdating = NO;
            [self checkAndUpdate];
        }];
    }
}

@end
