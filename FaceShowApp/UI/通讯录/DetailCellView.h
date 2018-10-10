//
//  DetailCellView.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCellView : UIView
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) BOOL needBottomLine;
@property (nonatomic, copy) void (^clickContentBlock)(NSString *content);

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;
@end
