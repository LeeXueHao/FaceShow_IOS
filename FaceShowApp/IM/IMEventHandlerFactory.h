//
//  IMEventHandlerFactory.h
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMEventHandler.h"

@interface IMEventHandlerFactory : NSObject
+ (IMEventHandler *)eventHandlerWithEventID:(NSUInteger)eventID;
@end
