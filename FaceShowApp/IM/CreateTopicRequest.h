//
//  CreateTopicRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/2/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "TopicData.h"

@interface CreateTopicRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *imEvent;
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSArray<TopicData_topic, Optional> *topic;
@end

@interface CreateTopicRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) CreateTopicRequestItem_data<Optional> *data;
@end

@interface CreateTopicRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *topicType; //主题类型： 1-私聊 2-群聊
@property (nonatomic, strong) NSString<Optional> *topicName;
@property (nonatomic, strong) NSString<Optional> *fromGroupTopicId;
@property (nonatomic, strong) NSString<Optional> *yxUsers;
@property (nonatomic, strong) NSString<Optional> *imMemberIds; 
@end
