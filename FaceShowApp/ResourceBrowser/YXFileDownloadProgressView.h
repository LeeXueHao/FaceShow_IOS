//
//  YXFileDownloadProgressView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXFileDownloadProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
//@property (nonatomic, copy) void(^closeBlock)();

@property (nonatomic, strong) UILabel *titleLabel;
@end
