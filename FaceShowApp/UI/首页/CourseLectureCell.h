//
//  CourseLectureCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCourseRequest.h"

@interface CourseLectureCell : UITableViewCell
@property (nonatomic, strong) GetCourseRequestItem_LecturerInfo *data;
@end
