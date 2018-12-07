//
//  YXResourceDisplayViewController.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ResourceDisplayViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXResourceDisplayViewController : ResourceDisplayViewController

/**
 ResourceTypeMapping 根据此字段判断资源类型
 */
@property (nonatomic, copy) NSString *suffix;
@end

NS_ASSUME_NONNULL_END
