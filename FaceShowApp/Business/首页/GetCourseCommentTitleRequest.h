//
//  GetCourseCommentTitleRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetCourseCommentTitleRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@end

@interface GetCourseCommentTitleRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCourseCommentTitleRequestItem_data<Optional> *data;
@end

@interface GetCourseCommentTitleRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@end
