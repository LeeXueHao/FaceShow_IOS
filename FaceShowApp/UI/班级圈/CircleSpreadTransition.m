//
//  CircleSpreadTransition.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CircleSpreadTransition.h"
#import "ShowPhotosViewController.h"
@implementation CircleSpreadTransition

+ (instancetype)transitionWithTransitionType:(CircleSpreadTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(CircleSpreadTransitionType)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (self.type) {
        case CircleSpreadTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case CircleSpreadTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    ShowPhotosViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromVC.view.hidden = YES;
    [transitionContext.containerView addSubview:toVC.view];
    fromVC.animateView.alpha = 1.0f;
    [transitionContext.containerView addSubview:fromVC.animateView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.animateView.frame = fromVC.animateRect;
        fromVC.animateView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [toVC.view removeFromSuperview];
        [fromVC.animateView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    ShowPhotosViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:toVC.view];
    toVC.view.frame = toVC.animateRect;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
