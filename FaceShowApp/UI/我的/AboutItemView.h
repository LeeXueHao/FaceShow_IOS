//
//  AboutItemView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutItemView : UIView

@property (nonatomic, copy) void(^clickBlock)(void);
@property (nonatomic, assign) BOOL showLine;
- (instancetype)initWithItemName:(NSString *)itemName;

@end

NS_ASSUME_NONNULL_END
