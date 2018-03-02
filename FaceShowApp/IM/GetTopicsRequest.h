//
//  GetTopicsRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "TopicData.h"

@interface GetTopicsRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) TopicData<Optional> *data;
@end

@interface GetTopicsRequest : YXGetRequest
@property (nonatomic, strong) NSString *reqId;
@property (nonatomic, strong) NSString *topicIds;
@end
