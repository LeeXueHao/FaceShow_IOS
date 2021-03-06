//
//  ScrollBaseViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/4/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ScrollBaseViewController : BaseViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat bottomHeightWhenKeyboardShows;
@end
