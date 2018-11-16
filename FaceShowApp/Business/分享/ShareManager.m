//
//  ShareManager.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ShareManager.h"

@interface ShareManager()

@end

@implementation ShareManager

+ (instancetype)sharedInstance {
    static ShareManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ShareManager alloc] init];
    });
    return manager;
}

- (NSString *)generateShareUrlWithOriginUrl:(NSString *)originUrl{
    NSString *totalUrl;
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    if (![originUrl containsString:@"?"]) {
        totalUrl = [NSString stringWithFormat:@"%@?userId=%@&shareTime=%@",originUrl,[UserManager sharedInstance].userModel.userID,timeString];
    }else{
        if ([originUrl hasSuffix:@"?"]) {
            totalUrl = [NSString stringWithFormat:@"%@userID=%@&shareTime=%@",originUrl,[UserManager sharedInstance].userModel.userID,timeString];
        }else{
            totalUrl = [NSString stringWithFormat:@"%@&userID=%@&shareTime=%@",originUrl,[UserManager sharedInstance].userModel.userID,timeString];
        }
    }
    return totalUrl;
}


@end
