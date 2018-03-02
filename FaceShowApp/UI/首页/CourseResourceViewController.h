//
//  CourseResourceViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "GetCourseRequest.h"

@interface CourseResourceViewController : BaseViewController
@property (nonatomic, strong) NSArray<GetCourseRequestItem_AttachmentInfo, Optional> *attachmentInfos;
@end
