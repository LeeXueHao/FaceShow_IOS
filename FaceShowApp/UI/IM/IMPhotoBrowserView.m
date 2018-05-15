//
//  IMPhotoBrowserView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMPhotoBrowserView.h"
#import "IMSlideImageView.h"
#import "AlertView.h"
#import "IMTopicMessage.h"
#import "IMImageMessageBaseCell.h"

@interface IMPhotoBrowserView ()<IMSlideViewDataSource, IMSlideViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, copy) PhotoBrowserViewSingleTapActionBlock block;
@end

@implementation IMPhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.slideView.currentIndex = currentIndex;
}

#pragma mark - setupUI
- (void)setupUI {
    
    self.slideView = [[IMSlideView alloc] init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.currentIndex = self.currentIndex;
    [self addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    WEAK_SELF
    self.singleTap = [[UITapGestureRecognizer alloc] init];
    [self.slideView addGestureRecognizer:self.singleTap];
    [[self.singleTap rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.block,self);
    }];
}

#pragma mark - IMSlideViewDataSource & IMSlideViewDelegate
- (NSInteger)numberOfItemsInSlideView:(IMSlideView *)slideView {
   return self.imageMessageArray.count;
}

- (QASlideItemBaseView *)slideView:(IMSlideView *)slideView itemViewAtIndex:(NSInteger)index {
    IMTopicMessage *message = self.imageMessageArray[index];
    CGFloat width = 0;
    CGFloat height = 0;
    if (message.width > 0 && message.height > 0) {
        width = message.width;
        height = message.height;
    }else {
        width = kMaxImageSizeHeight;
        height = kMaxImageSizeHeight;
    }
    IMSlideImageView *imageView = [[IMSlideImageView alloc] initWithImageWidth:width imageHeight:height];
    if (![message imageWaitForSending]) {
        NSString *urlString = message.viewUrl;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:urlString]];
        SDImageCache *cache = [SDImageCache sharedImageCache];
        UIImage *image = [cache imageFromDiskCacheForKey:key];
        if (image) {
            imageView.image = image;
        }else {
            [imageView.imageView nyx_startLoading];
            [imageView.imageView sd_setImageWithURL:[NSURL URLWithString:message.viewUrl] placeholderImage:[UIImage imageNamed:@"图片发送失败"]options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [imageView.imageView nyx_stopLoading];
            }];
        }
    }else {
        imageView.image = [message imageWaitForSending];
    }
    return imageView;
}

- (void)slideView:(IMSlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    self.currentIndex = to;
    IMSlideImageView *fromImageView = [slideView itemViewAtIndex:from];
    [fromImageView resetZoomScale];
    IMSlideImageView *toImageView = [slideView itemViewAtIndex:to];
    if (toImageView) {
        [self.singleTap requireGestureRecognizerToFail:toImageView.doubleTap];
    }
}

- (void)setPhotoBrowserViewSingleTapActionBlock:(PhotoBrowserViewSingleTapActionBlock)block {
    self.block = block;
}

@end
