//
//  ContactsDetailViewController.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface ContactsDetailViewController : ScrollBaseViewController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isAdministrator;
@end
