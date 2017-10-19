//
//  UserInfoViewController.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController
@property (nonatomic, strong) void(^completeBlock) (void);
@end
