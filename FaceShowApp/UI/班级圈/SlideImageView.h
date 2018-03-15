//
//  SlideImageView.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QASlideItemBaseView.h"

@interface SlideImageView : QASlideItemBaseView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

- (void)resetZoomScale;
@end
