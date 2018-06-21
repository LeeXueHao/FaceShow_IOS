//
//  SignInPLaceCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/5/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionSignInRequest.h"

typedef void(^SignInPlaceBlock)(void);
@interface SignInPLaceCell : UITableViewCell
@property (nonatomic, strong) GetSignInRecordListRequestItem_SignIn *data;
- (void)setSignInPlaceBlock:(SignInPlaceBlock)block;
@end
