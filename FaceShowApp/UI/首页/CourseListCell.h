//
//  CourseListCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCourseListRequest.h"

@interface CourseListCell : UITableViewCell
@property (nonatomic, strong) GetCourseListRequestItem_coursesList *item;
@property (nonatomic, copy) NSString *tagString;
@end
