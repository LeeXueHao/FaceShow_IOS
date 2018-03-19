//
//  IMPhotoBrowserView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMPhotoBrowserView.h"
#import "SlideImageView.h"
#import "AlertView.h"

@interface IMPhotoBrowserView ()<QASlideViewDataSource, QASlideViewDelegate>

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

#pragma mark - setupUI
- (void)setupUI {
    
    self.slideView = [[QASlideView alloc] init];
    self.slideView.backgroundColor = [UIColor blackColor];
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

#pragma mark - QASlideViewDataSource & QASlideViewDelegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    if (self.isUrlFormat) {
        return self.imageUrlStrArray.count;
    }
    return self.imageArray.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    SlideImageView *imageView = [[SlideImageView alloc] init];
    if (self.isUrlFormat) {
        [imageView.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlStrArray[index]] placeholderImage:[UIImage imageNamed:@"图片发送失败"]];
    }else {
        imageView.image = self.imageArray[index];
    }
    return imageView;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    self.currentIndex = to;
    SlideImageView *fromImageView = [slideView itemViewAtIndex:from];
    [fromImageView resetZoomScale];
    SlideImageView *toImageView = [slideView itemViewAtIndex:to];
    if (toImageView) {
        [self.singleTap requireGestureRecognizerToFail:toImageView.doubleTap];
    }
}

- (void)setPhotoBrowserViewSingleTapActionBlock:(PhotoBrowserViewSingleTapActionBlock)block {
    self.block = block;
}

@end
