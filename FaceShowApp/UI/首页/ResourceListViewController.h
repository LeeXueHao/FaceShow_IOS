//
//  ResourceListViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshDelegate.h"
#import "MainPageViewController.h"

@interface ResourceListViewController : BaseViewController<RefreshDelegate>
@property (nonatomic, weak) MainPageViewController *mainVC;
@end
