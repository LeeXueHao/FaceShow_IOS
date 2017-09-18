//
//  OptionItemView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionItemView : UIView
@property (nonatomic, strong) void(^clickBlock) (OptionItemView *view);
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *option;
@property (nonatomic, assign) BOOL editable;
@end
