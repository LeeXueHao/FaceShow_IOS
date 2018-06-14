//
//  ScroeDetailTabContainerView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScroeDetailTabContainerView : UIView
@property (nonatomic, strong) NSArray *tabNameArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) void (^tabClickBlock)(NSInteger index);
@end
