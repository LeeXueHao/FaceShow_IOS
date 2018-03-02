//
//  IMMessageMenuItem.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMMessageMenuItemType) {
    IMMessageMenuItemType_Cancel,
    IMMessageMenuItemType_Copy,
    IMMessageMenuItemType_Delete,
    IMMessageMenuItemType_Resend
};

@interface IMMessageMenuItem : UIMenuItem
@property (nonatomic, assign) IMMessageMenuItemType type;

@end
