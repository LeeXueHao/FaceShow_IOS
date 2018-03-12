//
//  TopicData.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "IMTopic.h"

@interface TopicData_memberInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *memberID;
@property (nonatomic, strong) NSString<Optional> *memberType;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *memberName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *state;
@end

@protocol TopicData_member
@end
@interface TopicData_member : JSONModel
@property (nonatomic, strong) NSString<Optional> *memberId;
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *talkMemberId;
@property (nonatomic, strong) NSString<Optional> *receivedMemberOpId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) TopicData_memberInfo<Optional> *memberInfo;

- (IMMember *)toIMMember;
@end

@protocol TopicData_topic
@end
@interface TopicData_topic : JSONModel
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *topicName;
@property (nonatomic, strong) NSString<Optional> *topicType;
@property (nonatomic, strong) NSString<Optional> *topicGroup;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *topicChange;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *latestMsgId;
@property (nonatomic, strong) NSString<Optional> *latestMsgTime;
@property (nonatomic, strong) NSArray<TopicData_member, Optional> *members;

- (IMTopic *)toIMTopic;
@end

@interface TopicData : JSONModel
@property (nonatomic, strong) NSString<Optional> *imEvent;
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSArray<TopicData_topic,Optional> *topic;
@end
