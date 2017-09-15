//
//  PhotoChooseCell.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoChooseCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, copy) void (^photoChooseBlock)(void);
@end
