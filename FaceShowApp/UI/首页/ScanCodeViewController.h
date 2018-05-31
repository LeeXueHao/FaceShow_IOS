//
//  ScanCodeViewController.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanCodeViewController : BaseViewController
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, assign) BOOL isShowSignInPlace;

@end
