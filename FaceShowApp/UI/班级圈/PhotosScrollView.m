//
//  PhotoScrollView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PhotosScrollView.h"
@interface PhotosScrollView ()<UIScrollViewDelegate>
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGPoint pointToCenterAfterResize;
@property (nonatomic, assign) CGFloat scaleToRestoreAfterResize;
@property (nonatomic, assign) BOOL aspectFill;

@end

@implementation PhotosScrollView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.aspectFill = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.scrollsToTop = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
    [self centerZoomView];
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
    
    [self centerZoomView];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomView;
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView
{
    [self centerZoomView];
}

#pragma mark - Center zoomView within scrollView

- (void)centerZoomView
{
    
    if (self.aspectFill) {
        CGFloat top = 0;
        CGFloat left = 0;
        
        if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
            top = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5f;
        }
        
        if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
            left = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5f;
        }
        
        self.contentInset = UIEdgeInsetsMake(top, left, top, left);
    } else {
        CGRect frameToCenter = self.zoomView.frame;
        
        if (CGRectGetWidth(frameToCenter) < CGRectGetWidth(self.bounds)) {
            frameToCenter.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(frameToCenter)) * 0.5f;
        } else {
            frameToCenter.origin.x = 0;
        }
        
        if (CGRectGetHeight(frameToCenter) < CGRectGetHeight(self.bounds)) {
            frameToCenter.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(frameToCenter)) * 0.5f;
        } else {
            frameToCenter.origin.y = 0;
        }
        
        self.zoomView.frame = frameToCenter;
    }
}

#pragma mark - Configure scrollView to display new image
- (void)displayImage:(UIImage *)image {
    [self.zoomView removeFromSuperview];
    self.zoomView = nil;
    
    self.zoomScale = 1.0;
    
    self.zoomView = [[UIImageView alloc] initWithImage:image];
    self.zoomView.userInteractionEnabled = YES;
    [self addSubview:self.zoomView];
    
    [self configureForImageSize:image.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    self.imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setInitialZoomScale];
    [self setInitialContentOffset];
    self.contentInset = UIEdgeInsetsZero;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width  / self.imageSize.width;
    CGFloat yScale = boundsSize.height / self.imageSize.height;
    CGFloat minScale;
    if (!self.aspectFill) {
        minScale = MIN(xScale, yScale);
    } else {
        minScale = MAX(xScale, yScale);
    }
    CGFloat maxScale = MAX(xScale, yScale);
    
    CGFloat xImageScale = maxScale*self.imageSize.width / boundsSize.width;
    CGFloat yImageScale = maxScale*self.imageSize.height / boundsSize.width;
    CGFloat maxImageScale = MAX(xImageScale, yImageScale);
    
    maxImageScale = MAX(minScale, maxImageScale);
    maxScale = MAX(maxScale, maxImageScale);
    
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)setInitialZoomScale {
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width  / self.imageSize.width;
    CGFloat yScale = boundsSize.height / self.imageSize.height;
    CGFloat scale = MAX(xScale, yScale);
    self.zoomScale = scale;
}

- (void)setInitialContentOffset
{
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.zoomView.frame;
    
    CGPoint contentOffset;
    if (CGRectGetWidth(frameToCenter) > boundsSize.width) {
        contentOffset.x = (CGRectGetWidth(frameToCenter) - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0;
    }
    if (CGRectGetHeight(frameToCenter) > boundsSize.height) {
        contentOffset.y = (CGRectGetHeight(frameToCenter) - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0;
    }
    
    [self setContentOffset:contentOffset];
}

#pragma mark - Rotation support

- (void)prepareToResize {
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.zoomView];
    self.scaleToRestoreAfterResize = self.zoomScale;
    if (self.scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        self.scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    [self setMaxMinZoomScalesForCurrentBounds];
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, self.scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    CGPoint boundsCenter = [self convertPoint:self.pointToCenterAfterResize fromView:self.zoomView];
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    self.contentOffset = offset;
}
- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}
- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}
@end
