//
//  GetCourseRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetCourseRequestItem_InteractStep <NSObject>
@end
@interface GetCourseRequestItem_InteractStep : JSONModel
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
@end

@protocol GetCourseRequestItem_AttachmentInfo <NSObject>
@end
@interface GetCourseRequestItem_AttachmentInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@property (nonatomic, strong) NSString<Optional> *transcodeStatus;
@property (nonatomic, strong) NSString<Optional> *resThumb;
@end

@protocol GetCourseRequestItem_LecturerInfo <NSObject>
@end
@interface GetCourseRequestItem_LecturerInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *lecturerName;
@property (nonatomic, strong) NSString<Optional> *lecturerBriefing;
@property (nonatomic, strong) NSString<Optional> *lecturerAvatar;
@end

@interface GetCourseRequestItem_Course : JSONModel
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *courseName;
@property (nonatomic, strong) NSString<Optional> *lecturer;
@property (nonatomic, strong) NSString<Optional> *site;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *briefing;
@property (nonatomic, strong) NSArray<GetCourseRequestItem_LecturerInfo, Optional> *lecturerInfos;
@property (nonatomic, strong) NSArray<GetCourseRequestItem_AttachmentInfo, Optional> *attachmentInfos;
@end

@interface GetCourseRequestItem_Data : JSONModel
@property (nonatomic, strong) GetCourseRequestItem_Course<Optional> *course;
@property (nonatomic, strong) NSArray<GetCourseRequestItem_InteractStep, Optional> *interactSteps;
@end

@interface GetCourseRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetCourseRequestItem_Data<Optional> *data;
@end

@interface GetCourseRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *courseId;
@end
