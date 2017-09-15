//
//  ShowPhotosViewController.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ShowPhotosViewController.h"
#import "CircleSpreadTransition.h"
#import "PhotosScrollView.h"
@interface ShowPhotosViewController ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ShowPhotosViewController

- (void)dealloc {
    DDLogDebug(@"release=====>>%@",NSStringFromClass([self class]));
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
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageModelMutableArray.count,SCREEN_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.numberOfPages = self.imageModelMutableArray.count;
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
    [self.imageModelMutableArray enumerateObjectsUsingBlock:^(PreviewPhotosModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotosScrollView *photoView = [[PhotosScrollView alloc] init];
        photoView.frame = CGRectMake((idx * SCREEN_WIDTH), 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        photoView.clipsToBounds = NO;
        photoView.tag = 10086 + idx;
        [self.scrollView addSubview:photoView];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        WEAK_SELF
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.original] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            STRONG_SELF
            if (error == nil) {
                [photoView displayImage:image];
                photoView.zoomScale = photoView.minimumZoomScale;
            }
        }];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
            STRONG_SELF
            if (x.state == UIGestureRecognizerStateEnded) {
                [self dismiss];
            }
        }];
        [photoView addGestureRecognizer:tapGestureRecognizer];
        UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [[longGestureRecognizer rac_gestureSignal] subscribeNext:^(UILongPressGestureRecognizer *x) {
            STRONG_SELF
            if (x.state == UIGestureRecognizerStateEnded) {
                [self saveImageToPhotos:photoView.zoomView.image];
            }
        }];
        [photoView addGestureRecognizer:longGestureRecognizer];
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-10.0f);
        make.size.mas_equalTo(CGSizeMake(20 * self.imageModelMutableArray.count, 10));
    }];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dismiss{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    self.scrollView.contentSize = CGSizeMake(size.width * self.imageModelMutableArray.count,size.height);
    [self.imageModelMutableArray enumerateObjectsUsingBlock:^(PreviewPhotosModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotosScrollView *photoView = [self.scrollView viewWithTag:10086 + idx];
        if (photoView != nil) {
            photoView.frame = CGRectMake(idx * size.width, 0, size.width, size.height);
        }
    }];
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
