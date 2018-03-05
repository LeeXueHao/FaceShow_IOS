//
//  MessagePromptView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePromptView : UIView
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) void(^confirmBlock)(void);
@end
