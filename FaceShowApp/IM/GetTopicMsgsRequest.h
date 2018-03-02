//
//  GetTopicMsgsRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "TopicMsgData.h"

@interface GetTopicMsgsRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) TopicMsgData<Optional> *data;
@end

@interface GetTopicMsgsRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *startId;
@property (nonatomic, strong) NSString<Optional> *order;  // desc(default) or asc
@property (nonatomic, strong) NSString<Optional> *dataNum; //default is 20
@end
