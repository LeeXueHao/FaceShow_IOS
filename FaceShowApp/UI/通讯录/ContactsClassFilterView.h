//
//  ContactsClassFilterView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContactsClassFilterCompletedBlock) (NSString *selectedTitle, NSInteger selectedRow);

@interface ContactsClassFilterView : UIView
@property(nonatomic, assign) NSInteger selectedRow;

- (void)setContactsClassFilterCompletedBlock:(ContactsClassFilterCompletedBlock)block;
- (CGFloat)heightForContactsClassFilterView;
@end
