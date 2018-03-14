//
//  SaveImageMsgRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "TopicMsgData.h"

@interface SaveImageMsgRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) TopicMsgData<Optional> *data;
@end

@interface SaveImageMsgRequest : YXPostRequest
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *reqId;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;
@end
