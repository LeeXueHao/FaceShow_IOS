//
//  UpgradePromptHandler.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXInitRequest.h"

@interface UpgradePromptHandler : NSObject
- (void)handleWithUpgradeBody:(YXInitRequestItem_Body *)body;
@end
