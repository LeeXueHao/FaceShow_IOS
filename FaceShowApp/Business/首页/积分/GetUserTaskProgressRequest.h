//
//  GetUserTaskProgressRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetUserTaskProgressRequestItem_interactType <NSObject>
@end

@interface GetUserTaskProgressRequestItem_interactType : JSONModel
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *taskNum;
@property (nonatomic, strong) NSString<Optional> *finishNum;
@property (nonatomic, strong) NSString<Optional> *interactTypeName;
@end

@interface GetUserTaskProgressRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsRank;
@property (nonatomic, strong) NSString<Optional> *finishPercent;
@property (nonatomic, strong) NSArray<Optional,GetUserTaskProgressRequestItem_interactType> *interactTypes;
@end

@interface GetUserTaskProgressRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserTaskProgressRequestItem_data<Optional> *data;
@end

@interface GetUserTaskProgressRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
