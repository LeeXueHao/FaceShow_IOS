//
//  PreviewPhotosView.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PreviewPhotosModel : NSObject
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *original;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImage *placeHolderImage;
@end

@interface PreviewPhotosView : UIView
@property (nonatomic, strong) NSMutableArray<PreviewPhotosModel*> *imageModelMutableArray;
/**
 展示图片总宽度 默认屏幕宽度
 */
@property (nonatomic, assign) CGFloat widthFloat;
/**
 图片间距（默认为5）
 */
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat verticalMargin;

/**
 显示图片的最大个数 默认9
 */
@property (nonatomic, assign) NSInteger photosMaxCount;

/**
 每行最多显示的个数(默认3个)
 */
@property (nonatomic, assign) NSInteger verticalMaxCount;

/**
 是否开启四张图双排 YES:开启 NO:关闭 (默认YES) 
 */
@property (nonatomic, assign) BOOL doubleRow;

- (void)reloadData;
@end
