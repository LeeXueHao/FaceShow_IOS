//
//  DefaultLoginContainerView.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultLoginContainerView : UIView
@property (nonatomic, copy, readonly) NSString *telPhoneNumber;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy) void(^loginBtnEnabledBlock)(BOOL btnEnabled);
- (void)refreshButton;
- (void)clearPassWord;
- (void)setFocus;
@end

NS_ASSUME_NONNULL_END
