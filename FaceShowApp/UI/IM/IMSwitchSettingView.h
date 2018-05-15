//
//  IMSwitchSettingView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMSwitchSettingView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) void(^stateChangeBlock)(BOOL isOn);
@end
