//
//  SlideImageView.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SlideImageView.h"

#define kMinZoomScale 1.0f //最小缩放倍数
#define kMaxZoomScale 2.0f //最大缩放倍数

@interface SlideImageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL layoutComplete;
@end

@implementation SlideImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
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

- (void)setImage:(ImageAttachment *)image {
    _image = image;
    if (image.image) {
        self.imageView.image = image.image;
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:image.url]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupLayout];
}

- (void)setupLayout {
    if (self.layoutComplete) {
        return;
    }
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat maxHeight = self.scrollView.bounds.size.height;
        CGFloat maxWidth = self.scrollView.bounds.size.width;
;
        if (width > maxWidth || height > width) {
            CGFloat ratio = height / width;
            CGFloat maxRatio = maxHeight / maxWidth;
            if (ratio < maxRatio) {
                width = maxWidth;
                height = width*ratio;
            } else {
                height = maxHeight;
                width = height / ratio;
            }
        }
        self.imageView.frame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
        self.scrollView.contentSize = self.imageView.frame.size;
        self.scrollView.zoomScale = 1.0f;
    } else {
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        self.scrollView.contentSize = self.imageView.frame.size;
    }
    self.scrollView.contentOffset = CGPointZero;
    self.layoutComplete = YES;
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

@end
