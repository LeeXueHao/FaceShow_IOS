//
//  ContactsClassFilterView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactMemberContactsRequestItem_Data_Gcontacts_Groups;

typedef void(^ContactsClassFilterCompletedBlock) (ContactMemberContactsRequestItem_Data_Gcontacts_Groups *selectedGroup, NSInteger selectedRow);

@interface ContactsClassFilterView : UIView
@property(nonatomic, assign) NSInteger selectedRow;
@property(nonatomic, strong) NSArray *dataArray;
- (void)setContactsClassFilterCompletedBlock:(ContactsClassFilterCompletedBlock)block;
- (CGFloat)heightForContactsClassFilterView;
- (void)reloadData;
@end
