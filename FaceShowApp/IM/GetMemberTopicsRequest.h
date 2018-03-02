//
//  GetMemberTopicsRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "TopicData.h"

@interface GetMemberTopicsRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) TopicData<Optional> *data;
@end

@interface GetMemberTopicsRequest : YXGetRequest
@property (nonatomic, strong) NSString *reqId;
@end
