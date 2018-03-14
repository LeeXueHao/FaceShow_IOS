//
//  TopicMsgData.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "IMTopicMessage.h"

@interface TopicMsgData_contentData : JSONModel
@property (nonatomic, strong) NSString<Optional> *msg;
@property (nonatomic, strong) NSString<Optional> *thumbnail;
@property (nonatomic, strong) NSString<Optional> *viewUrl;
@property (nonatomic, strong) NSString<Optional> *width;
@property (nonatomic, strong) NSString<Optional> *height;
@end

@protocol TopicMsgData_topicMsg
@end
@interface TopicMsgData_topicMsg : JSONModel
@property (nonatomic, strong) NSString<Optional> *msgId;
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *senderId;
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *contentType;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *sendTime;
@property (nonatomic, strong) TopicMsgData_contentData<Optional> *contentData;

- (IMTopicMessage *)toIMTopicMessage;
@end

@interface TopicMsgData : JSONModel
@property (nonatomic, strong) NSString<Optional> *imEvent;
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSArray<TopicMsgData_topicMsg,Optional> *topicMsg;

@end
