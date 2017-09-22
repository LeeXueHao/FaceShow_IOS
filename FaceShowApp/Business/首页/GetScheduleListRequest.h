//
//  GetScheduleListRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetScheduleListRequestItem_Schedule <NSObject>
@end
@interface GetScheduleListRequestItem_Schedule : JSONModel
@property (nonatomic, strong) NSString<Optional> *scheduleId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *remark;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *imageUrl;
@end

@interface GetScheduleListRequestItem_Data_Schedule : JSONModel
@property (nonatomic, strong) NSArray<GetScheduleListRequestItem_Schedule, Optional> *elements;
@end

@interface GetScheduleListRequestItem_Data : JSONModel
@property (nonatomic, strong) GetScheduleListRequestItem_Data_Schedule<Optional> *schedules;
@end

@interface GetScheduleListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetScheduleListRequestItem_Data<Optional> *data;
@end

@interface GetScheduleListRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
