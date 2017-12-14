//
//  StageSubjectViewController.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "StageSubjectItem.h"

@interface StageSubjectViewController : BaseViewController
@property (nonatomic, strong) StageSubjectItem_Stage *selectedStage;
@property (nonatomic, copy) void (^completeBlock)(void);
@end
