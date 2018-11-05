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

@property (nonatomic, readonly, assign) YXInputViewType type;

@end

NS_ASSUME_NONNULL_END
