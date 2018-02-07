//
//  PreviewPhotosView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PreviewPhotosView.h"
#import "ShowPhotosViewController.h"
#import "QiniuDataManager.h"
@implementation PreviewPhotosModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeHolderImage = [UIImage imageNamed:@"朋友圈一张图加载失败图片"];
    }
    return self;
}
@end
@interface PreviewPhotosView ()
@property (nonatomic, assign) CGSize photoSize;

@end
@implementation PreviewPhotosView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.widthFloat = SCREEN_WIDTH*[UIScreen mainScreen].scale;
        self.verticalMargin = 5.0f;
        self.horizontalMargin = 5.0f;
        self.doubleRow = YES;
        self.photosMaxCount = 9;
        self.verticalMaxCount = 3;
    }
    return self;
}
#pragma mark - set
- (CGSize)photoSize {
    return CGSizeMake((self.widthFloat - (self.verticalMaxCount - 1) * self.horizontalMargin)/(float)self.verticalMaxCount,(self.widthFloat - (self.verticalMaxCount - 1) * self.horizontalMargin)/(float)self.verticalMaxCount);
}

- (void)reloadData {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeConstraints:obj.constraints];
            [obj removeFromSuperview];
        }
    }];
    NSMutableArray<UIImageView *> *imageViewMutableArray = [[NSMutableArray<UIImageView *> alloc] initWithCapacity:9];
    [self.imageModelMutableArray enumerateObjectsUsingBlock:^(PreviewPhotosModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
        [imageView addSubview:placeholderImageView];
        imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageView);
        }];
        WEAK_SELF
        NSString *urlString = nil;
        if (self.imageModelMutableArray.count == 1) {
            urlString = obj.thumbnail;
        }else {
            urlString = [QiniuDataManager resizedUrlStringWithOriString:obj.thumbnail maxLongEdge:200];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil && error == nil) {
                [placeholderImageView removeFromSuperview];
                obj.placeHolderImage = image;
                imageView.backgroundColor = [UIColor clearColor];
            }
        }];
        imageView.tag = 10086 + idx;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            UITapGestureRecognizer * sender = x;
            if (sender.state == UIGestureRecognizerStateEnded) {
                [self presentNextViewController:imageView.tag];
            }
        }];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:imageView];
        [imageViewMutableArray addObject:imageView];
    }];
    [self setupPhotos:imageViewMutableArray];
}
- (void)presentNextViewController:(NSInteger )tag {
    UIImageView *imageView = [self viewWithTag:tag];
    ShowPhotosViewController *VC = [[ShowPhotosViewController alloc] init];
    VC.animateRect = [self convertRect:imageView.frame toView:self.window.rootViewController.view];
    VC.startInteger = tag - 10086;
    VC.imageModelMutableArray = self.imageModelMutableArray;
    __weak ShowPhotosViewController *wVC = VC;
    WEAK_SELF
    VC.showPhotosCurrentPage = ^(NSInteger page) {
        STRONG_SELF
        UIImageView *tempImageView = [self viewWithTag:10086 + page];
        wVC.animateRect = [self convertRect:tempImageView.frame toView:wVC.view];
    };
    [self.window.rootViewController presentViewController:VC animated:YES completion:^{
    }];
}

- (void)setupPhotos:(NSArray<UIImageView *>*)photos {
    if (self.imageModelMutableArray.count == 1) {
        [photos enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.top.equalTo(self.mas_top);
                make.height.equalTo(obj.mas_width).multipliedBy(348.0f/590.0f).priorityHigh();
                make.bottom.equalTo(self.mas_bottom);
            }];
        }];
    }else if (self.imageModelMutableArray.count == 4 && self.doubleRow) {
        [photos enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_top).offset((self.photoSize.height + self.verticalMargin) * (idx / 2) + self.photoSize.height/2.0f).priorityHigh();
                make.left.equalTo(self.mas_left).offset((self.photoSize.width + self.horizontalMargin) * (idx % 2));
                make.size.mas_offset(self.photoSize).priorityHigh();
            }];
        }];
    }else {
        [photos enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_top).offset((self.photoSize.height + self.verticalMargin) * (idx / 3) + self.photoSize.height/2.0f).priorityHigh();
                make.left.equalTo(self.mas_left).offset((self.photoSize.width + self.horizontalMargin) * (idx % 3));
                make.size.mas_offset(self.photoSize).priorityHigh();
            }];
            if (idx == photos.count -1 || idx == self.photosMaxCount - 1) {
                *stop = YES;
            }
        }];
    }
    
}


@end
