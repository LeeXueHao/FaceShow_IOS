//
//  YXDrawerController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSDynamicsDrawerViewController.h>
#import "YXDrawerViewController.h"

@interface YXDrawerController : NSObject

+ (void)showDrawer;
+ (void)hideDrawer;

+ (YXDrawerViewController *)drawer;

@end
