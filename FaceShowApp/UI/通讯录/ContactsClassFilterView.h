//
//  ContactsClassFilterView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassListRequestItem_clazsInfos;

typedef void(^ClazsListFilterCompletedBlock)(ClassListRequestItem_clazsInfos *selectClass,NSInteger selectedRow);

@interface ContactsClassFilterView : UIView
@property(nonatomic, assign) NSInteger selectedRow;
@property(nonatomic, strong) NSArray<ClassListRequestItem_clazsInfos *> *clazsArray;

- (void)setClazsFilterCompleteBlock:(ClazsListFilterCompletedBlock)block;

- (CGFloat)heightForContactsClassFilterView;
- (void)reloadData;
@end
