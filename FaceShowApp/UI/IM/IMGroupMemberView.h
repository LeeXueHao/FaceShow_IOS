//
//  IMGroupMemberView.h
//  FaceShowApp
//
//  Created by SRT on 2018/10/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMGroupMemberView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^clickContentBlock)(void);
@end

