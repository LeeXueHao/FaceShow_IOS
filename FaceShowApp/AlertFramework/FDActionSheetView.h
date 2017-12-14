//
//  FDActionSheetView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXNoFloatingHeaderFooterTableView.h"

@interface FDActionSheetView : YXNoFloatingHeaderFooterTableView
// NSDictionary[@"title":@"eg",@"subTitle";@"eg"]
@property (nonatomic, strong) NSArray<__kindof NSDictionary *> *titleArray;
@property (nonatomic, strong) NSString *tipsString;
@property (nonatomic, copy) void(^actionSheetBlock)(NSInteger integer);
@end

