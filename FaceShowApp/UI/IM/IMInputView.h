//
//  IMInputView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMInputView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) void(^completeBlock) (NSString *text);
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, assign) NSInteger maxTextNumber;
@property (nonatomic, strong) UIButton *cameraButton;


//TBD: 暂时实现自动改变输入框
@property (nonatomic, assign) BOOL isChangeBool;
@property (nonatomic, strong) void(^textHeightChangeBlock)(CGFloat textHeight);
@property (nonatomic, copy) NSString *textString;
@property (nonatomic, strong) void(^cameraButtonClickBlock)(void);

@end
