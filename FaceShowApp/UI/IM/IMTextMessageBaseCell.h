//
//  IMTextMessageBaseCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageBaseCell.h"

@interface IMTextMessageBaseCell : IMMessageBaseCell

@property (nonatomic, strong) UILabel *messageTextLabel;
- (CGFloat)textMaxWidth;
@end
