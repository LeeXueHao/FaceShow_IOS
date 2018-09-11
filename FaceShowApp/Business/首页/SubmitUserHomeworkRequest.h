//
//  SubmitUserHomeworkRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
@interface SubmitUserHomeworkRequest_data : JSONModel
@end

@interface SubmitUserHomeworkRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) SubmitUserHomeworkRequest_data<Optional> *data;
@end

@interface SubmitUserHomeworkRequest : YXPostRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *finishStatus; //完成状态：1-已完成（提交作业） 0-草稿，默认-1
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@property (nonatomic, strong) NSString<Optional> *attachment2;
@end
