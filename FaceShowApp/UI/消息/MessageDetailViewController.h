//
//  MessageDetailViewController.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface MessageDetailViewController : ScrollBaseViewController
@property (nonatomic, assign) BOOL viewed;
@property (nonatomic, strong) NSString *noticeId;
@property (nonatomic, strong) void (^fetchNoticeDetailSucceedBlock)(void);
@end
