//
//  OptionItemResultView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionRequestItem.h"

@interface OptionItemResultView : UIView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) QuestionRequestItem_voteItems *item;
@end
