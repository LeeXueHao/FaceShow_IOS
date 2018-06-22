//
//  SubmitUserHomeworkRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface SubmitUserHomeworkRequest_data : JSONModel
@end

@interface SubmitUserHomeworkRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) SubmitUserHomeworkRequest_data<Optional> *data;
@end

@interface SubmitUserHomeworkRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@end
