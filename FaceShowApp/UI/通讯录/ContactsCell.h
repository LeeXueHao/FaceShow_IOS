//
//  ContactsCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserInfoRequest.h"

@interface ContactsCell : UITableViewCell
@property (nonatomic, strong) GetUserInfoRequestItem_Data *data;
@property (nonatomic, assign) BOOL isLastRow;
@end

