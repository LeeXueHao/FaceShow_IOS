//
//  NBConfigManager.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetClassConfigRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface NBConfigManager : NSObject

+ (instancetype)sharedInstance;

- (UIViewController *)getViewControllerWithType:(NSString *)type pageConfig:(GetClassConfigRequest_Item_pageConf *)pageConf andTabConfigArray:(NSArray<GetClassConfigRequest_Item_tabConf *> *)tabArray;

@end

NS_ASSUME_NONNULL_END
