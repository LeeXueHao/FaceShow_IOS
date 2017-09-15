//
//  PhotoChooseCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PhotoChooseCell.h"
#import "PhotosScrollView.h"
@interface PhotoChooseCell ()
@property (nonatomic, strong) PhotosScrollView *photoView;
@end
@implementation PhotoChooseCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self setupUI];
    }
    return self;
}
#pragma mark - set
- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = photoImage;
    [self.photoView displayImage:_photoImage];
    self.photoView.zoomScale = self.photoView.minimumZoomScale;
}
#pragma mark - setupUI
- (void)setupUI {
    self.photoView = [[PhotosScrollView alloc] init];
    self.photoView.frame = CGRectMake(10.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f);
    self.photoView.clipsToBounds = NO;
    [self.contentView addSubview:self.photoView];
    WEAK_SELF
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        if (x.state == UIGestureRecognizerStateEnded) {
            BLOCK_EXEC(self.photoChooseBlock);
        }
    }];
    [self.photoView addGestureRecognizer:tapGestureRecognizer];
    UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [[longGestureRecognizer rac_gestureSignal] subscribeNext:^(UILongPressGestureRecognizer *x) {
        STRONG_SELF
        if (x.state == UIGestureRecognizerStateEnded) {
        }
    }];
    [self.photoView addGestureRecognizer:longGestureRecognizer];
}
@end
