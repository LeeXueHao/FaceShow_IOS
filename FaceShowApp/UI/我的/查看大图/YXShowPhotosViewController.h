//
//  YXShowPhotosViewController.h
//  FaceShowApp
//
//  Created by SRT on 2018/9/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "PreviewPhotosView.h"
@interface YXShowPhotosViewController : BaseViewController
/**
 查看退出图片动画开始返回位置
 */
@property (nonatomic, assign) CGRect animateRect;
/**
 退出动画显示图片
 */
@property (nonatomic, strong, readonly) UIView *animateView;


/**
  暂时弃用 改传下面的图片URL数组
 */
@property (nonatomic, strong) NSMutableArray<PreviewPhotosModel*> *imageModelMutableArray NS_UNAVAILABLE;

@property (nonatomic, strong) NSMutableArray<NSString*> *imageURLMutableArray;


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
