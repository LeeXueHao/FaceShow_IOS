//
//  FillQuestionCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillQuestionCell : UITableViewCell
@property (nonatomic, strong) void(^textChangeBlock) (NSString *text);
@property (nonatomic, assign) BOOL bottomLineHidden;
@end
