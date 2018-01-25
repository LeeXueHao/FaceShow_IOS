//
//  ClassMomentNotificationViewController.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassMomentNotificationViewController : BaseViewController
@property (nonatomic, copy) void(^classMomentNotificationReloadBlock)(void);
@end
