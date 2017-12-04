//
//  YXLocationManager.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLocationManager : NSObject

+ (YXLocationManager *)sharedInstance;

- (void)requestLocation;

@end
