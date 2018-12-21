//
//  ShareManager.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareManager : NSObject
+ (instancetype)sharedInstance;

- (NSString *)generateShareUrlWithOriginUrl:(NSString *)originUrl;

- (NSString *)generateLiveShareUrlWithOriginUrl:(NSString *)originUrl;

@end

NS_ASSUME_NONNULL_END
