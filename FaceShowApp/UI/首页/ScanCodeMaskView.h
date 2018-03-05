//
//  ScanCodeMaskView.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodeMaskView : UIView

@property (nonatomic,strong)NSTimer *scanTimer;
@property (nonatomic, strong) NSString *prompt;

@end
