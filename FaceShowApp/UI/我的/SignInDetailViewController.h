//
//  SignInDetailViewController.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"
@class GetSignInRecordListRequestItem_SignIn;

@interface SignInDetailViewController : ScrollBaseViewController
@property (nonatomic, strong) GetSignInRecordListRequestItem_SignIn *signIn;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end
