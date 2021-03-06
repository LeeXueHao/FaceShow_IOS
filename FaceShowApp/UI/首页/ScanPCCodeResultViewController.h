//
//  ScanPCCodeResultViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanPCCodeResultViewController : BaseViewController
@property (nonatomic, copy) NSString *scanType;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) void (^reScanCodeBlock)(void);
@end
