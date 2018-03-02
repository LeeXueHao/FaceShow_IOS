//
//  SaveTextMsgRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "TopicMsgData.h"

@interface SaveTextMsgRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) TopicMsgData<Optional> *data;
@end

@interface SaveTextMsgRequest : YXGetRequest
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *reqId;
@property (nonatomic, strong) NSString *msg;
@end
