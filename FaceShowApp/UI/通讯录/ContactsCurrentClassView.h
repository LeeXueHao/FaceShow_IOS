//
//  ContactsCurrentClassView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContactsClassStartFilterBlock) (NSString *currentTitle);

@interface ContactsCurrentClassView : UIView
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL isFiltering;
@property(nonatomic, copy) NSString *selectClassId;

- (void)setContactsClassStartFilterBlock:(ContactsClassStartFilterBlock)block;

@end
