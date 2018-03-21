//
//  IMSlideView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QASlideItemBaseView.h"

@class IMSlideView;

@protocol IMSlideViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInSlideView:(IMSlideView *)slideView;
- (QASlideItemBaseView *)slideView:(IMSlideView *)slideView itemViewAtIndex:(NSInteger)index;
@end

@protocol IMSlideViewDelegate <NSObject>
@optional
- (void)slideView:(IMSlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to;
- (void)slideViewDidReachMostLeft:(IMSlideView *)slideView;
- (void)slideViewDidReachMostRight:(IMSlideView *)slideView;
@end


@interface IMSlideView : UIView
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isActive; // default is YES
@property (nonatomic, weak) id<IMSlideViewDataSource> dataSource;
@property (nonatomic, weak) id<IMSlideViewDelegate> delegate;
@property (nonatomic, assign) BOOL canScroll;

- (void)scrollToItemIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;
- (__kindof QASlideItemBaseView *)itemViewAtIndex:(NSInteger)index; // maybe nil if not loaded or has been recycled.

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end
