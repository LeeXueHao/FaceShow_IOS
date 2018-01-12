//
//  PhotoBrowserController.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoBrowserController : BaseViewController
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) void (^didDeleteImage)(void);
@property (nonatomic, copy) void (^deleteImageBlock)(NSInteger index);
@end
