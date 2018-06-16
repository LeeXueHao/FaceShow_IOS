//
//  GetAllTasksRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetAllTasksRequestItem_task <NSObject>
@end

@interface GetAllTasksRequestItem_task : JSONModel
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *interactName;
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *interactId;
@property (nonatomic, strong) NSString<Optional> *stepStatus;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepFinished;
@property (nonatomic, strong) NSString<Optional> *interactTypeName;
@property (nonatomic, strong) NSString<Optional> *totalStudentNum;
@property (nonatomic, strong) NSString<Optional> *finishedStudentNum;
@property (nonatomic, strong) NSString<Optional> *percent;

@end

@protocol GetAllTasksRequestItem_interactType <NSObject>
@end
@interface GetAllTasksRequestItem_interactType : JSONModel
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *taskNum;
@property (nonatomic, strong) NSString<Optional> *finishNum;
@property (nonatomic, strong) NSString<Optional> *finishPercent;
@property (nonatomic, strong) NSString<Optional> *interactTypeName;
@end

@interface GetAllTasksRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetAllTasksRequestItem_task, Optional> *tasks;
@property (nonatomic, strong) NSArray<GetAllTasksRequestItem_interactType, Optional> *interactTypes;

@end

@interface GetAllTasksRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetAllTasksRequestItem_data<Optional> *data;
@end

@interface GetAllTasksRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
