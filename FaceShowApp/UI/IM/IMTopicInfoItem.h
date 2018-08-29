//
//  IMTopicInfoItem.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/8/24.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMMember;
@class ContactMemberContactsRequestItem_Data_Gcontacts_Groups;

@interface IMTopicInfoItem : NSObject
@property (nonatomic, strong) IMMember *member;
@property (nonatomic, strong) ContactMemberContactsRequestItem_Data_Gcontacts_Groups *group;
@end
