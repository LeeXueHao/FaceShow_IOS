//
//  ScanCodeResultViewController.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"
#import "UserSignInRequest.h"

@interface ScanCodeResultViewController : ScrollBaseViewController
@property (nonatomic, copy) void (^reScanCodeBlock)();
@property (nonatomic, strong) UserSignInRequestItem_Data *data;
@property (nonatomic, strong) NSError *error;
@end
