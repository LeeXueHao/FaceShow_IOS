//
//  UpdatePersonalConfigRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "TopicData.h"

@interface UpdatePersonalConfigRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) TopicData<Optional> *data;
@end


@interface UpdatePersonalConfigRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *bidId;
@property (nonatomic, strong) NSString<Optional> *topicId; 
@property (nonatomic, strong) NSString<Optional> *quite;//免打扰：0-关闭 1-启用 空-不设置
@end
