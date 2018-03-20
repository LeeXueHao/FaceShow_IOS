//
//  ContactsCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactMemberContactsRequest.h"

@interface ContactsCell : UITableViewCell
@property (nonatomic, strong) ContactMemberContactsRequestItem_Data_Gcontacts_ContactsInfo *data;
@property(nonatomic, assign) BOOL isShowLine;
@end

