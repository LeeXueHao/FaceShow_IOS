//
//  ClassListRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ClassListRequestItem_clazsInfos<NSObject>
@end
@interface ClassListRequestItem_clazsInfos: JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@property (nonatomic, strong) NSString<Optional> *clazsStatus;
@property (nonatomic, strong) NSString<Optional> *clazsType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *clazsStatusName;
@property (nonatomic, strong) NSString<Optional> *projectName;
@end

@interface ClassListRequestItem_data: JSONModel
@property (nonatomic, strong) NSArray<Optional,ClassListRequestItem_clazsInfos> *clazsInfos;
@end

@interface ClassListRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) ClassListRequestItem_data<Optional> *data;
@end

@interface ClassListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@end
