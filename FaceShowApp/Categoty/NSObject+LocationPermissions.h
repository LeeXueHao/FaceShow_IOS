//
//  NSObject+LocationPermissions.h
//  FaceShowApp
//
//  Created by ZLL on 2018/8/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LocationPermissions)
/**
 怕段当前应用是否打开位置权限

 @return YES表示打开了位置权限,NO表示没有打开
 */
- (BOOL)determineWhetherTheAPPOpensTheLocation;
@end
