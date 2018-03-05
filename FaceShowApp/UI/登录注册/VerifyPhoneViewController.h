//
//  VerifyPhoneViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface VerifyPhoneViewController : ScrollBaseViewController
@property (nonatomic, strong) NSString *classID;
@property (nonatomic, copy) void (^reScanCodeBlock)(void);
@end
