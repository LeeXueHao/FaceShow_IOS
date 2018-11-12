//
//  NBMeetingListRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetCourseListRequest.h"

@protocol NBGetMeetingListRequestItem_Group <NSObject>
@end
@interface NBGetMeetingListRequestItem_Group : JSONModel
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *categoryName;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *virtualId;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSArray<Optional,GetCourseListRequestItem_coursesList> *courses;
- (CGFloat)cellHeight;
@end


@protocol NBGetMeetingListRequestItem_Courses <NSObject>
@end
@interface NBGetMeetingListRequestItem_Courses : JSONModel
@property (nonatomic, strong) NSString<Optional> *date;
@property (nonatomic, strong) NSString<Optional> *isToday;
@property (nonatomic, strong) NSArray<Optional,NBGetMeetingListRequestItem_Group> *group;
@end

@interface NBGetMeetingListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<Optional,NBGetMeetingListRequestItem_Courses> *courses;
@end


@interface NBGetMeetingListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NBGetMeetingListRequestItem_Data<Optional> *data;
@end

@interface NBGetMeetingListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
