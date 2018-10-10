//
//  ContactsListCell.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserInfoRequest.h"

@interface ContactsListCell : UITableViewCell
@property (nonatomic, strong) GetUserInfoRequestItem_Data *data;
@property (nonatomic, assign) BOOL isLastRow;
@end
