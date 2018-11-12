//
//  MeetingListCell.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBGetMeetingListRequestItem_Group;
NS_ASSUME_NONNULL_BEGIN

@interface MeetingListCell : UITableViewCell
@property (nonatomic, strong) NBGetMeetingListRequestItem_Group *group;
@end

NS_ASSUME_NONNULL_END
