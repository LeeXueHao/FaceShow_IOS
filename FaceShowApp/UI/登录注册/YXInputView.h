//
//  YXInputView.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXInputViewType) {
    YXInputViewType_Default,
    YXInputViewType_QuickLogin
};


NS_ASSUME_NONNULL_BEGIN

@interface YXInputView : UIView

@property (nonatomic, assign) YXInputViewType type;
@property (nonatomic, copy) void(^sendVerifyCodeBlock)(NSString *telPhoneNumber);
@property (nonatomic, copy) void(^btnEnabledBlock)(BOOL enabled);
@property (nonatomic, copy, readonly) NSString *telPhoneNumber;
@property (nonatomic, copy, readonly) NSString *password;
- (void)startTimer;
- (void)stopTimer;
- (void)clearPassWord;
- (void)setFocus;
@end

NS_ASSUME_NONNULL_END
