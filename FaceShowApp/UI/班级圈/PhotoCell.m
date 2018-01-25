//
//  PhotoCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoItem
- (instancetype)init {
    if (self = [super init]) {
        self.canSelect = YES;
    }
    return self;
}
@end

@interface PhotoCell()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIImageView *coverView;
@end

@implementation PhotoCell
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.photoImageView = [[UIImageView alloc]init];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIButton *topButton = [[UIButton alloc]init];
    [topButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.topButton = topButton;
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image = [UIImage imageNamed:@"单选未选择"];
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.right.mas_equalTo(-3);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    self.coverView = [[UIImageView alloc]init];
    self.coverView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [self.contentView addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.clickBlock);
}

- (void)setPhotoItem:(PhotoItem *)photoItem {
    _photoItem = photoItem;
    [self updateWithImage:photoItem.image];
    if (!photoItem.image) {
        CGSize size = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2);
        size = CGSizeMake(120, 120);
        WEAK_SELF
        [[PHCachingImageManager defaultManager] requestImageForAsset:photoItem.asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            STRONG_SELF
            [self handleResultImage:result];
        }];
    }
    for (UIView *v in self.selectImageView.subviews) {
        [v removeFromSuperview];
    }
    if (photoItem.selected) {
        UILabel *lb = [[UILabel alloc]init];
        lb.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
        lb.text = [NSString stringWithFormat:@"%@",@(photoItem.selectedIndex)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:14];
        lb.textColor = [UIColor whiteColor];
        lb.layer.cornerRadius = 12;
        lb.clipsToBounds = YES;
        [self.selectImageView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    self.coverView.hidden = photoItem.canSelect;
}

- (void)updateWithImage:(UIImage *)image {
    self.photoImageView.image = image;
}

- (void)handleResultImage:(UIImage *)resultImage {
    CGSize size = CGSizeMake(120, 120);
    __block UIImage *image = resultImage;
    [self performBackgroundTaskWithBlock:^{
        image = [resultImage nyx_aspectFillImageWithSize:size];
    } completeBlock:^{
        self.photoItem.image = image;
        [self updateWithImage:image];
    }];
//    if (!resultImage) {
//        return;
//    }
//    self.photoItem.image = resultImage;
//    [self updateWithImage:resultImage];
}
@end
