//
//  LiveNavigationView.h
//  FaceShowApp
//
//  Created by SRT on 2018/12/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveNavigationView : UIView

@property (nonatomic, copy) void(^forwardActionBlock)(void);
@property (nonatomic, copy) void(^backActionBlock)(void);

- (void)refreshForwardEnabled:(BOOL)forwardEnabled backEnabled:(BOOL)backEnabled;

@end

NS_ASSUME_NONNULL_END
