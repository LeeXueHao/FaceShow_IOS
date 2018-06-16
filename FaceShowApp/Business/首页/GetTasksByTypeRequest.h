//
//  GetTasksByTypeRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetTasksByTypeRequestItem_task <NSObject>
@end

@interface GetTasksByTypeRequestItem_task : JSONModel
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

@interface GetTasksByTypeRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetTasksByTypeRequestItem_task, Optional> *data;
@end

@interface GetTasksByTypeRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString *interactType;
@end
