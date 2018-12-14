//
//  YXMenuLabel.m
//  FaceShowApp
//
//  Created by srt on 2018/12/13.
//  Copyright © 2018 niuzhaowang. All rights reserved.
//

#import "YXMenuLabel.h"

@interface YXMenuLabel ()

@property (nonatomic, strong) UIMenuController *menuController;

@end

@implementation YXMenuLabel

#pragma mark- Live circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}

#pragma mark- Overwrite
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(cancelAction:) || action == @selector(copyAction:)) {
        return YES;
    }
    return NO;
}

#pragma mark- Interface methods
- (void)allowLongPress {
    self.userInteractionEnabled = YES;
}

- (void)forbidLongPress {
    self.userInteractionEnabled = NO;
}

#pragma mark- Event Response methods
- (void)cancelAction:(UIMenuController *)sender {
    [self.menuController setMenuVisible:NO animated:YES];
    [self resignFirstResponder];
}

- (void)copyAction:(UIMenuController *)sender {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
}

- (void)longPress:(UIGestureRecognizer *)gestureRecognizer {
    // 设置label为第一响应者
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    [self becomeFirstResponder];
        
    // 自定义 UIMenuController
    self.menuController = [UIMenuController sharedMenuController];
    UIMenuItem *cancelItem = [[UIMenuItem alloc]initWithTitle:@"取消" action:@selector(cancelAction:)];
    UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    
    self.menuController.menuItems = @[copyItem, cancelItem];
    [self.menuController setTargetRect:self.bounds inView:self];
    [self.menuController setMenuVisible:YES animated:YES];
}

#pragma mark- Private methods
- (void)prepare {
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)]];
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIMenuControllerWillHideMenuNotification object:nil] subscribeNext:^(id x) {
//        self.backgroundColor = [UIColor clearColor];
//    }];
}

#pragma mark- Setter and getter

@end
