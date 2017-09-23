//
//  FillQuestionResultCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionRequestItem.h"

@interface FillQuestionResultCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) QuestionRequestItem_question *item;
@property (nonatomic, assign) BOOL bottomLineHidden;
@end
