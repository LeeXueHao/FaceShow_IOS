//
//  NBResourceListViewController.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "NBMainPageViewController.h"
#import "RefreshDelegate.h"

@interface NBResourceListViewController : BaseViewController<RefreshDelegate>
@property (nonatomic, strong) NBMainPageViewController *mainVC;
@end


