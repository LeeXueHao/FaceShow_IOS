//
//  IMMessageMenuView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/1/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageMenuView.h"

@implementation IMMessageMenuItemModel
@end

@interface IMMessageMenuView ()
@property (nonatomic, strong) UIMenuController *menuController;
@end

@implementation IMMessageMenuView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.menuController = [UIMenuController sharedMenuController];
        [self.menuController setArrowDirection:UIMenuControllerArrowDown];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)addMenuItemModels:(NSArray<IMMessageMenuItemModel *> *)itemModels {
    NSMutableArray *array = [NSMutableArray array];
    
    [itemModels enumerateObjectsUsingBlock:^(IMMessageMenuItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == IMMessageMenuItemType_Cancel) {
            UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:obj.title action:@selector(cancelAction:)];
            [array addObject:item];
        }else if (obj.type == IMMessageMenuItemType_Copy) {
            UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:obj.title action:@selector(copyAction:)];
            [array addObject:item];
        }else if (obj.type == IMMessageMenuItemType_Delete) {
            UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:obj.title action:@selector(deleteAction:)];
            [array addObject:item];
        }else if (obj.type == IMMessageMenuItemType_Resend) {
            UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:obj.title action:@selector(resendAction:)];
            [array addObject:item];
        }
    }];
    self.itemArray = array.copy;
    [self.menuController setMenuItems:self.itemArray];
}

- (void)cancelAction:(UIMenuController *)sender {
    [self menuItemActionWithType:IMMessageMenuItemType_Cancel];
}

- (void)copyAction:(UIMenuController *)sender {
    [self menuItemActionWithType:IMMessageMenuItemType_Copy];
}

- (void)deleteAction:(UIMenuController *)sender {
    [self menuItemActionWithType:IMMessageMenuItemType_Delete];
}

- (void)resendAction:(UIMenuController *)sender {
    [self menuItemActionWithType:IMMessageMenuItemType_Resend];
}

- (void)menuItemActionWithType:(IMMessageMenuItemType)type {
    _isShow = NO;
    [self removeFromSuperview];
    BLOCK_EXEC(self.block,type);
}

- (void)showInView:(UIView *)view withRect:(CGRect)rect {
    _isShow = YES;
    [self setFrame:view.bounds];
    [view addSubview:self];
    
    [self becomeFirstResponder];
    [self.menuController setTargetRect:rect inView:self];
    [self.menuController setMenuVisible:YES animated:YES];
    
}

- (void)dismiss
{
    _isShow = NO;
    BLOCK_EXEC(self.block,IMMessageMenuItemType_Cancel);
    [self.menuController setMenuVisible:NO animated:YES];
    [self removeFromSuperview];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(cancelAction:) || action == @selector(cancelAction:) || action == @selector(copyAction:) || action == @selector(deleteAction:) || action == @selector(resendAction:)) {
        return YES;
    }
    return NO;
}

- (void)setMenuItemActionBlock:(MenuItemActionBlock)block {
    self.block = block;
}
@end
