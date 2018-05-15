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

@interface IMTopicUpdateItem : NSObject
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) void(^completeBlock)(NSArray<IMTopic *> *,NSError *error);
@end

@implementation IMTopicUpdateItem
@end

@interface IMTopicUpdateService()
@property (nonatomic, strong) NSMutableArray<IMTopicUpdateItem *> *topicArray;
@property (nonatomic, assign) BOOL isTopicUpdating;
@end

@implementation IMTopicUpdateService

+ (IMTopicUpdateService *)sharedInstance {
    static IMTopicUpdateService *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IMTopicUpdateService alloc] init];
        manager.topicArray = [NSMutableArray array];
        manager.isTopicUpdating = NO;
    });
    return manager;
}

- (void)addTopic:(IMTopic *)topic withCompleteBlock:(void (^)(NSArray<IMTopic *> *, NSError *))completeBlock{
    IMTopicUpdateItem *item = [[IMTopicUpdateItem alloc]init];
    item.topic = topic;
    item.completeBlock = completeBlock;
    [self.topicArray addObject:item];
    [self checkAndUpdate];
}

- (void)checkAndUpdate{
    if (!self.isTopicUpdating && self.topicArray.count>0) {
        self.isTopicUpdating = YES;
        IMTopicUpdateItem *item = [self.topicArray firstObject];
        WEAK_SELF
        [[IMRequestManager sharedInstance]requestTopicDetailWithTopicIds:[NSString stringWithFormat:@"%@",@(item.topic.topicID)] completeBlock:^(NSArray<IMTopic *> *topics, NSError *error) {
            STRONG_SELF
            for (IMTopic *topic in topics) {
                [[IMDatabaseManager sharedInstance]saveTopic:topic];
            }
            BLOCK_EXEC(item.completeBlock,topics,error);
            [self.topicArray removeObjectAtIndex:0];
            self.isTopicUpdating = NO;
            [self checkAndUpdate];
        }];
    }
}

@end
