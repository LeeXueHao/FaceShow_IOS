//
//  ContactsSearchBarView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsSearchBarView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) void(^searchBlock)(NSString *text);
@end
