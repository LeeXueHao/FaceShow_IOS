//
//  UIViewController+NavigationItem.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/4/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(void);

@interface UIViewController (NavigationItem)
- (UIButton *)nyx_setupLeftWithTitle:(NSString *)title action:(ActionBlock)action;
- (UIButton *)nyx_setupLeftWithImage:(UIImage *)image action:(ActionBlock)action;
- (UIButton *)nyx_setupLeftWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(ActionBlock)action;
- (void)nyx_setupLeftWithCustomView:(UIView *)view;
- (UIButton *)nyx_setupRightWithImage:(UIImage *)image action:(ActionBlock)action;
- (UIButton *)nyx_setupRightWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(ActionBlock)action;
- (UIButton *)nyx_setupRightWithTitle:(NSString *)title action:(ActionBlock)action;
- (void)nyx_setupRightWithCustomView:(UIView *)view;

- (void)nyx_enableRightNavigationItem;
- (void)nyx_disableRightNavigationItem;
@end
