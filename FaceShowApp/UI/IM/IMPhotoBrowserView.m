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
@property (nonatomic, strong) UIButton *downloadBtn;
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

    self.downloadBtn = [[UIButton alloc] init];
    [self.downloadBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [self addSubview:self.downloadBtn];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-30);
        } else {

            make.bottom.mas_equalTo(-30);
        }
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [[self.downloadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        IMTopicMessage *message = self.imageMessageArray[self.currentIndex];
        if (![message imageWaitForSending]) {
            NSString *urlString = message.viewUrl;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:urlString]];
            SDImageCache *cache = [SDImageCache sharedImageCache];
            UIImage *image = [cache imageFromDiskCacheForKey:key];
            if (image) {
                [self saveImageToPhotos:image];
            }else {
                [self nyx_startLoading];
                [manager loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    [self nyx_stopLoading];
                    if (image) {
                        [self saveImageToPhotos:image];
                    }else{
                        [self nyx_showToast:@"保存图片失败"];
                    }

                }];
            }
        }else{
            [self saveImageToPhotos:[message imageWaitForSending]];
        }
    }];
}

- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error != NULL){
        [self nyx_showToast:@"保存图片失败"];
    }else{
        [self nyx_showToast:@"已保存到系统相册"];
    }
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
