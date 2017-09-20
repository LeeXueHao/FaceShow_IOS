//
//  FillQuestionCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionRequestItem.h"

@interface FillQuestionCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) QuestionRequestItem_question *item;
@property (nonatomic, assign) BOOL bottomLineHidden;
@property (nonatomic, strong) void(^textChangeBlock) (NSString *text);
@property (nonatomic, strong) void(^endEdittingBlock) ();
@end
