//
//  OptionItemResultView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionResult : NSObject
@property (nonatomic, strong) NSString *option;
@property (nonatomic, assign) CGFloat rate;
@end

@interface OptionItemResultView : UIView
@property (nonatomic, strong) OptionResult *option;
@end
