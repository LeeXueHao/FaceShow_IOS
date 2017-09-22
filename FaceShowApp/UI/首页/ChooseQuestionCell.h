//
//  ChooseQuestionCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionRequestItem.h"

@interface ChooseQuestionCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) QuestionRequestItem_question *item;
@property (nonatomic, assign) BOOL bottomLineHidden;
@property (nonatomic, strong) void(^answerChangeBlock) ();
@property (nonatomic, assign) BOOL editable;
@end
