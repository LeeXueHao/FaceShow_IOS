//
//  GetScheduleListRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetScheduleListRequest.h"

@implementation GetScheduleListRequestItem_meetingPlans
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"meetingPlanId"}];
}
@end

@implementation GetScheduleListRequestItem_userSeatMsg
@end

@implementation GetScheduleListRequestItem_Meeting
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"meetingId"}];
}
@end

@implementation GetScheduleListRequestItem_attachmentInfo
@end

@implementation GetScheduleListRequestItem_Schedule
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"scheduleId"}];
}
@end

@implementation GetScheduleListRequestItem_Data_Schedule
@end

@implementation GetScheduleListRequestItem_Data
@end

@implementation GetScheduleListRequestItem
@end

@implementation GetScheduleListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"schedule.list";
        self.isApp = @"1";
    }
    return self;
}
@end
