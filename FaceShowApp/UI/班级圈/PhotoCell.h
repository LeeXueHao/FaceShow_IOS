//
//  PhotoCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoItem : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL canSelect;
@end

@interface PhotoCell : UICollectionViewCell
@property (nonatomic, strong) PhotoItem *photoItem;
@property (nonatomic, strong) void(^clickBlock)(void);
@end
