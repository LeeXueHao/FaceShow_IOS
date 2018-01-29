//
//  CommentInputView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentInputView : UIView
@property (nonatomic, strong) void(^completeBlock) (NSString *text);
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, assign) NSInteger maxTextNumber;

@property (nonatomic, strong) NSString *placeHolder;

//TBD: 暂时实现自动改变输入框 
@property (nonatomic, assign) BOOL isChangeBool;
@property (nonatomic, strong) void(^textHeightChangeBlock)(CGFloat textHeight);
@property (nonatomic, copy) NSString *textString;

@end
