//
//  CircleSpreadTransition.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, CircleSpreadTransitionType) {
    CircleSpreadTransitionTypePresent = 0,
    CircleSpreadTransitionTypeDismiss
};
@interface CircleSpreadTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CircleSpreadTransitionType type;

+ (instancetype)transitionWithTransitionType:(CircleSpreadTransitionType)type;
- (instancetype)initWithTransitionType:(CircleSpreadTransitionType)type;
@end
