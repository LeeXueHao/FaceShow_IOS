//
//  GetScheduleListRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"


@protocol GetScheduleListRequestItem_meetingPlans <NSObject> @end
@interface GetScheduleListRequestItem_meetingPlans : JSONModel
@property (nonatomic, strong) NSString<Optional> *planName;
@property (nonatomic, strong) NSString<Optional> *meetingId;
@property (nonatomic, strong) NSString<Optional> *planContent;
@property (nonatomic, strong) NSString<Optional> *seatZoneId;
@property (nonatomic, strong) NSString<Optional> *planType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *meetingPlanId;
@end

@interface GetScheduleListRequestItem_userSeatMsg : JSONModel
@property (nonatomic, strong) NSString<Optional> *meetingId;
@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, strong) NSString<Optional> *seatGroupId;
@property (nonatomic, strong) NSString<Optional> *seat;
@property (nonatomic, strong) NSString<Optional> *userSeatId;
@property (nonatomic, strong) NSString<Optional> *zoneId;
@end

@protocol GetScheduleListRequestItem_Meeting <NSObject>
@end
@interface GetScheduleListRequestItem_Meeting : JSONModel
@property (nonatomic, strong) NSString<Optional> *groupType;
@property (nonatomic, strong) NSArray<GetScheduleListRequestItem_meetingPlans,Optional> *meetingPlans;
@property (nonatomic, strong) NSString<Optional> *scheduleId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *meetingName;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) GetScheduleListRequestItem_userSeatMsg<Optional> *userSeatMsg;
@property (nonatomic, strong) NSString<Optional> *seatZones;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *meetingId;
@end

@interface GetScheduleListRequestItem_attachmentInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resKey;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *ext;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@property (nonatomic, strong) NSString<Optional> *transcodeStatus;
@property (nonatomic, strong) NSString<Optional> *resThumb;
@property (nonatomic, strong) NSString<Optional> *resSource;
@end

@protocol GetScheduleListRequestItem_Schedule <NSObject>
@end
@interface GetScheduleListRequestItem_Schedule : JSONModel
@property (nonatomic, strong) NSString<Optional> *scheduleId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *scheduleType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *remark;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *imageUrl;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@property (nonatomic, strong) GetScheduleListRequestItem_attachmentInfo<Optional> *attachmentInfo;
@property (nonatomic, strong) NSArray<GetScheduleListRequestItem_Meeting, Optional> *meetings;
@property (nonatomic, strong) NSString<Optional> *toUrl;
@end

@interface GetScheduleListRequestItem_Data_Schedule : JSONModel
@property (nonatomic, strong) NSArray<GetScheduleListRequestItem_Schedule, Optional> *elements;
@end

@interface GetScheduleListRequestItem_Data : JSONModel
@property (nonatomic, strong) GetScheduleListRequestItem_Data_Schedule<Optional> *schedules;
@property (nonatomic, strong) GetScheduleListRequestItem_Data_Schedule<Optional> *personalSchedules;
@end

@interface GetScheduleListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetScheduleListRequestItem_Data<Optional> *data;
@end

@interface GetScheduleListRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString<Optional> *isApp;

@end
