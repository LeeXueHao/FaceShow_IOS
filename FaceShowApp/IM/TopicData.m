//
//  TopicData.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TopicData.h"
#import "IMConfig.h"

@implementation TopicData_memberInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"memberID"}];
}
@end

@implementation TopicData_member
- (IMMember *)toIMMember {
    IMMember *member = [[IMMember alloc]init];
    member.memberID = self.memberInfo.memberID.longLongValue;
    member.userID = self.memberInfo.userId.longLongValue;
    member.avatar = self.memberInfo.avatar;
    member.name = self.memberInfo.memberName;
    return member;
}
@end

@implementation TopicData_topic
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"topicId"}];
}

- (IMTopic *)toIMTopic {
    IMTopic *topic = [[IMTopic alloc]init];
    topic.type = self.topicType.longLongValue;
    topic.topicID = self.topicId.longLongValue;
    topic.channel = [IMConfig topicForTopicID:self.topicId.longLongValue];
    topic.name = self.topicName;
    topic.group = self.topicGroup;
    topic.topicChange = self.topicChange.longLongValue;
    topic.latestMsgId = self.latestMsgId.longLongValue;
    NSMutableArray *members = [NSMutableArray array];
    for (TopicData_member *item in self.members) {
        [members addObject:[item toIMMember]];
    }
    topic.members = members;
    return topic;
}

@end

@implementation TopicData

@end
