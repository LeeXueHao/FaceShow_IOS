//
//  SexItemView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexItemView : UIView
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) void(^selectionBlock) (void);
@end
