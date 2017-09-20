//
//  CourseListViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshDelegate.h"

@interface CourseListViewController : BaseViewController<RefreshDelegate>
- (instancetype)initWithClazsId:(NSString *)clazsId;
@end
