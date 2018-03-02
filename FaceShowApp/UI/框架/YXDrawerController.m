//
//  YXDrawerController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDrawerController.h"

@implementation YXDrawerController

+ (void)showDrawer{
    YXDrawerViewController *drawerVC = [self drawer];
    [drawerVC showDrawer];
    [TalkingData trackEvent:@"打开左侧抽屉"];
}

+ (void)hideDrawer{
    YXDrawerViewController *drawerVC = [self drawer];
    [drawerVC hideDrawer];
}

+ (YXDrawerViewController *)drawer{
    YXDrawerViewController *drawerVC = (YXDrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([drawerVC isKindOfClass:[YXDrawerViewController class]]) {
        return drawerVC;
    }
    return nil;
}


@end
