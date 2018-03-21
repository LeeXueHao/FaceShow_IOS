//
//  IMSlideImageView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMSlideImageView.h"
#define kMinZoomScale 1.0f //最小缩放倍数
#define kMaxZoomScale 3.0f //最大缩放倍数

@interface IMSlideImageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@end

@implementation IMSlideImageView

- (instancetype)initWithImageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight {
    if (self = [super init]) {
        _imageWidth = imageWidth;
        _imageHeight = imageHeight;
         [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)resetZoomScale {
    self.scrollView.zoomScale = 1.0f;
}

#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = kMaxZoomScale;
    self.scrollView.minimumZoomScale = kMinZoomScale;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [self.doubleTap setNumberOfTapsRequired:2];
    [self.imageView addGestureRecognizer:self.doubleTap];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setupLayout {
    CGSize size = [self aspectFitOriginalSize:CGSizeMake(self.imageWidth / [UIScreen mainScreen].scale, self.imageHeight / [UIScreen mainScreen].scale) withReferenceSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];
    self.scrollView.contentSize = size;
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

#pragma mark - handleDoubleTap
- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer {
    UIGestureRecognizerState state = recongnizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.scrollView.zoomScale == self.scrollView.minimumZoomScale;
            CGFloat scale = zoomOut?self.scrollView.maximumZoomScale:self.scrollView.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.zoomScale = scale;
                if(zoomOut){
                    CGFloat x = touchPoint.x*scale - self.scrollView.bounds.size.width / 2;
                    CGFloat maxX = self.scrollView.contentSize.width-self.scrollView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.scrollView.bounds.size.height / 2;
                    CGFloat maxY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.scrollView.contentOffset = CGPointMake(x, y);
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (CGSize)aspectFitOriginalSize:(CGSize)originalSize withReferenceSize:(CGSize)referenceSize {
    CGFloat scaleW = originalSize.width / referenceSize.width;
    CGFloat scaleH = originalSize.height / referenceSize.height;
    CGFloat scale = MAX(scaleH, scaleW);
    CGSize scaledSize = CGSizeMake(originalSize.width / scale, originalSize.height / scale);
    return scaledSize;
}
@end
