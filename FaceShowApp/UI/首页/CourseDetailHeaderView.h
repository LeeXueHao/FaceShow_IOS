//
//  CourseDetailHeaderView.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetCourseRequestItem_Course;

@interface CourseDetailHeaderView : UIView

@property (nonatomic, strong) GetCourseRequestItem_Course *course;
@property (nonatomic, copy) void (^viewAllBlock)();

@end
