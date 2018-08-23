//
//  DeleteView.h
//  testtv
//
//  Created by niuzhaowang on 2018/8/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteView : UIView
@property (nonatomic, strong) void(^deleteBlock)(void);
@end
