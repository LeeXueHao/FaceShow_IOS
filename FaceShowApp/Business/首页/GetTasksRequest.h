//
//  GetTasksRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetTasksRequestItem_task <NSObject>
@end

@interface GetTasksRequestItem_task : JSONModel
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *taskNum;
@property (nonatomic, strong) NSString<Optional> *finishNum;
@property (nonatomic, strong) NSString<Optional> *interactTypeName;
@end

@interface GetTasksRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetTasksRequestItem_task, Optional> *data;
@end


@interface GetTasksRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;

@end
