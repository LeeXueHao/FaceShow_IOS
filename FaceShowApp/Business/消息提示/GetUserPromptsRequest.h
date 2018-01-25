//
//  GetUserPromptsRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/12/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetUserPromptsRequestItem_taskNew: JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *promptNum;
@property (nonatomic, strong) NSString<Optional> *bizId;
@end

@interface GetUserPromptsRequestItem_momentNew: JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *promptNum;
@property (nonatomic, strong) NSString<Optional> *bizId;
@end

@interface GetUserPromptsRequestItem_resourceNew: JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *promptNum;
@property (nonatomic, strong) NSString<Optional> *bizId;
@end

@interface GetUserPromptsRequestItem_data: JSONModel
@property (nonatomic, strong) GetUserPromptsRequestItem_taskNew<Optional> *taskNew;
@property (nonatomic, strong) GetUserPromptsRequestItem_momentNew<Optional> *momentNew;
@property (nonatomic, strong) GetUserPromptsRequestItem_resourceNew<Optional> *resourceNew;
@property (nonatomic, strong) GetUserPromptsRequestItem_resourceNew<Optional> *momentMsgNew;

@end

@interface GetUserPromptsRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) GetUserPromptsRequestItem_data<Optional> *data;
@end

@interface GetUserPromptsRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *bizIds;
@end
