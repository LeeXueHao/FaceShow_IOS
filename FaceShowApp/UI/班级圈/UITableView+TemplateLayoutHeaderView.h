//
//  UITableView+TemplateLayoutHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TemplateLayoutHeaderView)
- (CGFloat)yx_heightForHeaderWithIdentifier:(NSString *)identifier configuration:(void (^)(id header))configuration;
@end
