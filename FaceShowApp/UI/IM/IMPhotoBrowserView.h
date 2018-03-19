//
//  IMPhotoBrowserView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QASlideView.h"
@class IMPhotoBrowserView;

typedef void(^PhotoBrowserViewSingleTapActionBlock) (IMPhotoBrowserView *view);

@interface IMPhotoBrowserView : UIView
@property (nonatomic, strong) NSMutableArray *imageUrlStrArray;//传入图片的Url
@property (nonatomic, assign) BOOL isUrlFormat;//传的数据源的格式是否是Url
@property (nonatomic, strong) NSMutableArray *imageArray;//传入图片
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) QASlideView *slideView;

- (void)setPhotoBrowserViewSingleTapActionBlock:(PhotoBrowserViewSingleTapActionBlock)block;
@end
