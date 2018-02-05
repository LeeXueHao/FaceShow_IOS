//
//  QuestionnaireHeaderView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionnaireHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

+ (CGFloat)heightForTitle:(NSString *)title desc:(NSString *)desc;
@end
