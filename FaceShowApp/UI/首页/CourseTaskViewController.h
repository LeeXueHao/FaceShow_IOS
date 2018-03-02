//
//  CourseTaskViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "GetCourseRequest.h"

@interface CourseTaskViewController : BaseViewController
@property (nonatomic, strong) NSArray<GetCourseRequestItem_InteractStep, Optional> *interactSteps;
@end
