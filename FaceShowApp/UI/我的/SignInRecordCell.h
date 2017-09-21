//
//  SignInRecordCell.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetSignInRecordListRequestItem_SignIn;

@interface SignInRecordCell : UITableViewCell
@property (nonatomic, assign) BOOL hasBottomLine;
@property (nonatomic, strong) GetSignInRecordListRequestItem_SignIn *signIn;
@end
