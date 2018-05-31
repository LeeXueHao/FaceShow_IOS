//
//  SignInPLaceCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/5/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignInPlaceBlock)(void);
@interface SignInPLaceCell : UITableViewCell

- (void)setSignInPlaceBlock:(SignInPlaceBlock)block;
@end
