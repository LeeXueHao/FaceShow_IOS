//
//  QuickLoginContainerView.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickLoginContainerView : UIView
@property (nonatomic, copy, readonly) NSString *telPhoneNumber;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy) void(^verifyCodeBlock)(NSString *telPhoneNumber);
@property (nonatomic, copy) void(^loginBtnEnabledBlock)(BOOL btnEnabled);
- (void)refreshButton;
- (void)startTimer;
- (void)stopTimer;
- (void)setFocus;
@end

NS_ASSUME_NONNULL_END
