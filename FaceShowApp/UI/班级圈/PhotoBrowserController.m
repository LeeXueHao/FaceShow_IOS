//
//  PhotoBrowserController.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PhotoBrowserController.h"
#import "QASlideView.h"
#import "SlideImageView.h"
#import "AlertView.h"
#import "FDActionSheetView.h"

@interface PhotoBrowserController ()<QASlideViewDataSource, QASlideViewDelegate>
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL barHidden;
@end

@implementation PhotoBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.cantNotDeleteImage) {
        [self setupNavigationBar];
    }
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WEAK_SELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG_SELF
        self.barHidden = YES;
    });
}

//- (void)backAction {
//    [super backAction];
//    if (isEmpty(self.images)) {
//        BLOCK_EXEC(self.didDeleteImage);
//    }
//}

#pragma mark -
- (void)removeCurrentImage {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"删除"}];
    actionSheetView.tipsString = @"要删除这张照片吗？";
    AlertView *alertView = [[AlertView alloc] init];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.hideWhenMaskClicked = YES;
    alertView.contentView = actionSheetView;
    WEAK_SELF
    [alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(155.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(155.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (integer == 1) {
            [self.view nyx_showToast:@"已删除"];
            [self.images removeObjectAtIndex:self.currentIndex];
            [self.slideView reloadData];
            BLOCK_EXEC(self.deleteImageBlock,self.currentIndex);
            if (isEmpty(self.images)) {
                [self backAction];
            }
        }
        [alertView hide];
    };
}

#pragma mark - setupNavigationBar
- (void)setupNavigationBar {
    WEAK_SELF
    [self nyx_setupRightWithImageName:@"删除按钮正常态" highlightImageName:@"删除按钮点击态" action:^{
        STRONG_SELF
        [self removeCurrentImage];
    }];
}

#pragma mark - barHidden
- (void)setBarHidden:(BOOL)barHidden {
    _barHidden = barHidden;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:self.barHidden animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return self.barHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - setupUI
- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.slideView = [[QASlideView alloc] init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.currentIndex = self.currentIndex;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    WEAK_SELF
    self.singleTap = [[UITapGestureRecognizer alloc] init];
    [self.slideView addGestureRecognizer:self.singleTap];
    [[self.singleTap rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        self.barHidden = !self.barHidden;
    }];
}

#pragma mark - QASlideViewDataSource & QASlideViewDelegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.images.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    SlideImageView *imageView = [[SlideImageView alloc] init];
    imageView.image = self.images[index];
    return imageView;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    self.navigationItem.title = [NSString stringWithFormat:@"%@/%@", @(to + 1), @(self.images.count)];
    self.currentIndex = to;
    SlideImageView *fromImageView = [slideView itemViewAtIndex:from];
    [fromImageView resetZoomScale];
    SlideImageView *toImageView = [slideView itemViewAtIndex:to];
    if (toImageView) {
        [self.singleTap requireGestureRecognizerToFail:toImageView.doubleTap];
    }
}

@end
