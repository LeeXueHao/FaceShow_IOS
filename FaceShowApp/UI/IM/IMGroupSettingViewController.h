//
//  IMGroupSettingViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "IMTopic.h"

@interface IMGroupSettingViewController : BaseViewController
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) IMTopic *topic;
@end
