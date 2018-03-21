//
//  IMSlideImageView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QASlideItemBaseView.h"

@interface IMSlideImageView : QASlideItemBaseView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
- (instancetype)initWithImageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;
- (void)resetZoomScale;
@end
