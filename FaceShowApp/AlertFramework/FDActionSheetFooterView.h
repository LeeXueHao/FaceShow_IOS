//
//  FDActionSheetFooterView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDActionSheetFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^actionSheetCancleBlock)(void);
@end
