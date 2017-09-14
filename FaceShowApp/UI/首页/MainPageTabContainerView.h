//
//  MainPageTabContainerView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageTabContainerView : UIView
@property (nonatomic, strong) NSArray *tabNameArray;
@property (nonatomic, strong) void (^tabClickBlock)(NSInteger index);
@end
