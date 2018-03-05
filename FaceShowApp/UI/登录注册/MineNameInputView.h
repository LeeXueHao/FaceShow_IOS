//
//  MineNameInputView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineInputView.h"

@interface MineNameInputView : UIView
@property (nonatomic, strong) MineInputView *inputView;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong) void(^textChangeBlock) (void);
@end
