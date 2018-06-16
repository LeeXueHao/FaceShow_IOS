//
//  UpdateHomeworkRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface UpdateHomeworkRequestItem_data : JSONModel
@end

@interface UpdateHomeworkRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) UpdateHomeworkRequestItem_data<Optional> *data;
@end

@interface UpdateHomeworkRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@end


