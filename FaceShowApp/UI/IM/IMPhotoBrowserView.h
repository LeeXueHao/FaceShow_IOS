//
//  IMPhotoBrowserView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QASlideView.h"
#import "IMSlideView.h"
@class IMPhotoBrowserView;
@class IMTopicMessage;

typedef void(^PhotoBrowserViewSingleTapActionBlock) (IMPhotoBrowserView *view);

@interface IMPhotoBrowserView : UIView
@property (nonatomic, strong) NSMutableArray<IMTopicMessage *> *imageMessageArray;//传入图片的Url
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) IMSlideView *slideView;

- (void)setPhotoBrowserViewSingleTapActionBlock:(PhotoBrowserViewSingleTapActionBlock)block;
@end
