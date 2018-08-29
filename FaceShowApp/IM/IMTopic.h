//
//  IMTopic.h
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMember.h"
#import "IMTopicMessage.h"

typedef NS_ENUM(int64_t, TopicType) {
    TopicType_Group = 2,
    TopicType_Private = 1
};

@interface IMTopic : NSObject
@property (nonatomic, assign) TopicType type;
@property (nonatomic, assign) int64_t topicID;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, assign) int64_t groupID;
@property (nonatomic, assign) int64_t latestMsgId;
@property (nonatomic, assign) int64_t topicChange;
@property (nonatomic, assign) int64_t unreadCount;
@property (nonatomic, strong) IMTopicMessage *latestMessage;
@property (nonatomic, strong) NSArray<IMMember *> *members;
@property (nonatomic, assign) BOOL isClearedHistory;
@end
