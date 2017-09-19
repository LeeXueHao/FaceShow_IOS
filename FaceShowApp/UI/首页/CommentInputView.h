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
@end
