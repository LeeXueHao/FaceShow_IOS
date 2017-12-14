//
//  PageNameMappingTable.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageNameMappingTable : NSObject
+ (NSString *)pageNameForViewControllerName:(NSString *)vcName;
@end
