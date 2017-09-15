//
//  PhotoScrollView.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosScrollView : UIScrollView
@property (nonatomic, strong) UIImageView *zoomView;
- (void)displayImage:(UIImage *)image;
@end
