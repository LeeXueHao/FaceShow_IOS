//
//  NBMeetingListRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBGetMeetingListRequest.h"

@implementation NBGetMeetingListRequestItem_Group{
    CGFloat cellHeight;
}
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"groupId",@"virtual":@"virtualId"}];
}
- (void)setCourses:(NSArray<Optional,GetCourseListRequestItem_coursesList> *)courses{
    _courses = courses;
    if (courses.count) {
        dispatch_async(dispatch_queue_create("calculateCellHeight", 0), ^{
            CGFloat lastLeftMargin = 15;
            CGFloat lastTopMargin = 17 + 16;
            for (GetCourseListRequestItem_coursesList *courseList in courses) {
                CGSize size = [courseList.courseName sizeWithFont:[UIFont systemFontOfSize:14]];
                if (lastLeftMargin + size.width + 26 + 15 > SCREEN_WIDTH) {
                    lastLeftMargin = 15;
                    lastTopMargin += size.height + 16;
                }
                lastLeftMargin += size.width + 26 + 15;
            }
            self->cellHeight = lastTopMargin;
        });
    }else{
        self->cellHeight = 0;
    }
}

- (CGFloat)cellHeight{
    return self->cellHeight;
}

@end

@implementation NBGetMeetingListRequestItem_Courses
@end

@implementation NBGetMeetingListRequestItem_Data
@end

@implementation NBGetMeetingListRequestItem
@end

@implementation NBGetMeetingListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].server1_1;
        self.method = @"app.clazs.courses";
    }
    return self;
}
@end
