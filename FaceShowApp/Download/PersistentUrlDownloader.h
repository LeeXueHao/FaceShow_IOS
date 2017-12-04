//
//  PersistentUrlDownloader.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/20.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "UrlDownloader.h"

@interface PersistentUrlDownloader : UrlDownloader

+ (BOOL)fileExist:(NSString *)aUrl;
+ (void)removeFile:(NSString *)aUrl;
+ (NSString *)localPathForUrl:(NSString *)aUrl;
@end
