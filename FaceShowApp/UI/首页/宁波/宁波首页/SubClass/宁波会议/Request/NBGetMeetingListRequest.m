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
    if (self.courses.count > 0 && [self.virtualId isEqualToString:@"0"]) {
        [self calculateCellheight];
    }else{
        self->cellHeight = 0;
    }
}

- (void)setVirtualId:(NSString<Optional> *)virtualId{
    _virtualId = virtualId;
    if ([virtualId isEqualToString:@"0"] && self.courses.count > 0) {
        [self calculateCellheight];
    }else{
        self->cellHeight = 0;
    }
}

- (void)calculateCellheight{
    dispatch_async(dispatch_queue_create("calculHeightQueue", 0), ^{
        CGFloat leftMargin = 15;
        CGFloat containerHeight = 30;
        for (int i = 0; i < self.courses.count; i ++) {
            GetCourseListRequestItem_coursesList *courseList = self.courses[i];
            CGSize size = [courseList.courseName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            if (leftMargin + size.width + 26 + 15 > SCREEN_WIDTH) {
                leftMargin = 15;
                containerHeight += size.height + 16 + 8;
            }
            leftMargin += size.width + 26 + 4;
        }
        self->cellHeight = containerHeight;
    });
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
