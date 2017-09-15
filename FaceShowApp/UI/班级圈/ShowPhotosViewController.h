//
//  ShowPhotosViewController.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "PreviewPhotosView.h"
@interface ShowPhotosViewController : BaseViewController
/**
 查看退出图片动画开始返回位置
 */
@property (nonatomic, assign) CGRect animateRect;
/**
 退出动画显示图片
 */
@property (nonatomic, strong, readonly) UIView *animateView;


@property (nonatomic, strong) NSMutableArray<PreviewPhotosModel*> *imageModelMutableArray;


//单一图片显示不需要设置
/**
 其实图片位置
 */
@property (nonatomic, assign) NSInteger startInteger;
/**
 当前移动到哪个位置
 */
@property (nonatomic, copy) void(^showPhotosCurrentPage)(NSInteger page);
@end
