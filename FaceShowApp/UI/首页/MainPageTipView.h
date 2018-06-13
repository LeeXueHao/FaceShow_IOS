//
//  MainPageTipView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCurrentClazsRequest.h"

@interface MainPageTipView : UIView
@property (nonatomic, strong) GetCurrentClazsRequestItem *item;
@property (nonatomic, copy) void(^selectedTipBlock)(GetCurrentClazsRequestItem *item);
@end
