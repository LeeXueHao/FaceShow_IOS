//
//  GroupMemberCell.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailByStudentRequest.h"

@interface GroupMemberCell : UITableViewCell
@property (nonatomic, strong) GroupDetailByStudentRequest_Item_students *students;
@property (nonatomic, assign) BOOL isLastRow;
@end


