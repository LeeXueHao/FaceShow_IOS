//
//  GetCurrentClazsRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetCurrentClazsRequestItem_projectManagerInfo <NSObject>
@end
@interface GetCurrentClazsRequestItem_projectManagerInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *managerId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *userName;
@end

@interface GetCurrentClazsRequestItem_projectInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *projectStatus;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSArray<Optional,GetCurrentClazsRequestItem_projectManagerInfo> *projectManagerInfos;
@end

@interface GetCurrentClazsRequestItem_clazsInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@property (nonatomic, strong) NSString<Optional> *clazsStatus;
@property (nonatomic, strong) NSString<Optional> *clazsType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *desc;
@end

@interface GetCurrentClazsRequestItem_data : JSONModel
@property (nonatomic, strong) GetCurrentClazsRequestItem_projectInfo<Optional> *projectInfo;
@property (nonatomic, strong) GetCurrentClazsRequestItem_clazsInfo<Optional> *clazsInfo;
@end

@interface GetCurrentClazsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCurrentClazsRequestItem_data<Optional> *data;
@end

@interface GetCurrentClazsRequest :YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
