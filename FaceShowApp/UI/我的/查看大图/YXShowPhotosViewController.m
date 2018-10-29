//
//  YXShowPhotosViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXShowPhotosViewController.h"
#import "CircleSpreadTransition.h"
#import "PhotosScrollView.h"
@interface YXShowPhotosViewController ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL appeared;
@end

@implementation YXShowPhotosViewController

- (void)dealloc {
    DDLogDebug(@"release=====>>%@",NSStringFromClass([self class]));
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.view.clipsToBounds = YES;
    [self setupUI];
    [self setupLayout];
    [self setupContentScrollView];
}
- (UIView *)animateView {
    PhotosScrollView *photoView = [self.scrollView viewWithTag:10086 + self.pageControl.currentPage];
    return photoView.zoomView;
}
#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageURLMutableArray.count,SCREEN_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentOffset = CGPointMake(self.startInteger*SCREEN_WIDTH, 0);
    [self.view addSubview:self.scrollView];

    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.numberOfPages = self.imageURLMutableArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"3f4044"];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.currentPage = self.startInteger;
    WEAK_SELF
    [[self.pageControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIPageControl * x) {
        STRONG_SELF
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * x.currentPage, 0) animated:YES];
        BLOCK_EXEC(self.showPhotosCurrentPage ,x.currentPage);
    }];
    [self.view addSubview:self.pageControl];
}

- (void)setupContentScrollView {
    [self.imageURLMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotosScrollView *photoView = [[PhotosScrollView alloc] init];
        photoView.frame = CGRectMake((idx * SCREEN_WIDTH), 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        photoView.clipsToBounds = NO;
        photoView.tag = 10086 + idx;
        [self.scrollView addSubview:photoView];
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
        [photoView addSubview:placeholderImageView];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(photoView);
            make.size.mas_offset(CGSizeMake(170.0f, 50.f));
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        photoView.zoomView = imageView;
        photoView.backgroundColor = [UIColor clearColor];
        [photoView nyx_startLoading];
        WEAK_SELF
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            STRONG_SELF
            [photoView nyx_stopLoading];
            if (image != nil && error == nil) {
                photoView.backgroundColor = [UIColor blackColor];
                [placeholderImageView removeFromSuperview];
                [photoView displayImage:image];
                photoView.zoomScale = photoView.minimumZoomScale;
            }
        }];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
            STRONG_SELF
            if (x.state == UIGestureRecognizerStateEnded) {
                [self dismiss];
            }
        }];
        [photoView addGestureRecognizer:tapGestureRecognizer];
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] init];
        doubleClick.numberOfTapsRequired = 2;
        doubleClick.numberOfTouchesRequired = 1;
        [[doubleClick rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            [photoView setZoomScale:photoView.minimumZoomScale animated:YES];
        }];
        [photoView addGestureRecognizer:doubleClick];
        [tapGestureRecognizer requireGestureRecognizerToFail:doubleClick];
        UIButton *downLoad = [[UIButton alloc] init];
        [downLoad setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        [self.view addSubview:downLoad];
        [downLoad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-30);
            } else {

                make.bottom.mas_equalTo(-30);
            }
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [[downLoad rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            if (photoView.zoomView.image != nil) {
                [self saveImageToPhotos:photoView.zoomView.image];
            }
        }];
    }];
}
- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error != NULL){
        [self.view nyx_showToast:@"保存图片失败"];
    }else{
        [self.view nyx_showToast:@"已保存到系统相册"];
    }
}


- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10.f);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10.0f);
            // Fallback on earlier versions
        }
        make.size.mas_equalTo(CGSizeMake(20 * self.imageURLMutableArray.count, 10));
    }];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.appeared = YES;
}

- (void)dismiss{
    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(self.scrollView.contentOffset.x / SCREEN_WIDTH);
    BLOCK_EXEC(self.showPhotosCurrentPage ,self.pageControl.currentPage);
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [CircleSpreadTransition transitionWithTransitionType:CircleSpreadTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [CircleSpreadTransition transitionWithTransitionType:CircleSpreadTransitionTypeDismiss];
}

@end
