//
//  CompleteUserInfoViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "SysUserItem.h"

@interface CompleteUserInfoViewController : BaseViewController
@property (nonatomic, strong) SysUserItem *userItem;
@property (nonatomic, assign) BOOL isYanXiuUser;
@property (nonatomic, strong) NSString *className;
@end
