//
//  IMEventHandlerFactory.m
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMEventHandlerFactory.h"
#import "IMNewMessageEventHandler.h"
#import "IMNewTopicEventHandler.h"
#import "IMTopicChangeEventHandler.h"

@implementation IMEventHandlerFactory

+ (IMEventHandler *)eventHandlerWithEventID:(NSUInteger)eventID {
    if (eventID == EventType_NewMessage) {
        return [[IMNewMessageEventHandler alloc]init];
    }else if (eventID == EventType_NewTopic) {
        return [[IMNewTopicEventHandler alloc]init];
    }else if (eventID == EventType_TopicAddMember || eventID == EventType_TopicRemoveMember) {
        return [[IMTopicChangeEventHandler alloc]init];
    }
    return nil;
}

@end
