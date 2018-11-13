//
//  MeetingListCell.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetCourseListRequestItem_coursesList;
NS_ASSUME_NONNULL_BEGIN

@interface MeetingListCell : UITableViewCell
@property (nonatomic, strong) GetCourseListRequestItem_coursesList *item;
@end

NS_ASSUME_NONNULL_END
