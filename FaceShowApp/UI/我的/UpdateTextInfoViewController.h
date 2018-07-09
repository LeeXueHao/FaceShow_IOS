//
//  UpdateTextInfoViewController.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/7/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoNameModel.h"
@interface UpdateTextInfoViewController : BaseViewController
@property (nonatomic, strong) void(^completeBlock) (void);
@property (nonatomic, assign) UserInfoNameType infoType;
@end
