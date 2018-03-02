//
//  IMMessageMenuView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessageMenuItem.h"

@interface IMMessageMenuItemModel :NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) IMMessageMenuItemType type;
@end

typedef void(^MenuItemActionBlock) (IMMessageMenuItemType type);

@interface IMMessageMenuView : UIView
@property (nonatomic, strong) NSArray <IMMessageMenuItem *> *itemArray;

@property (nonatomic, assign, readonly) BOOL isShow;
//@property (nonatomic, copy) void (^actionBlcok)(IMMessageMenuItemType type);


@property(nonatomic, copy) MenuItemActionBlock block;

//- (void)showInView:(UIView *)view withItemModels:(NSArray <IMMessageMenuItemModel *> *)itemModels rect:(CGRect)rect actionBlock:(void (^)(IMMessageMenuItemType))actionBlock;
- (void)addMenuItemModels:(NSArray <IMMessageMenuItemModel *> *)itemModels;
- (void)setMenuItemActionBlock:(MenuItemActionBlock)block;
- (void)showInView:(UIView *)view withRect:(CGRect)rect;
- (void)dismiss;

@end
