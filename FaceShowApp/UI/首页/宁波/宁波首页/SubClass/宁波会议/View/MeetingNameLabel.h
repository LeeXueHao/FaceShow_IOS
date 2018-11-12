//
//  MeetingNameLabel.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingNameLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
- (instancetype)initWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
