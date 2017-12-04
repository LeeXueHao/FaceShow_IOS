//
//  DownloadManager.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/17/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDownloader.h"

@interface DownloadManager : NSObject
+ (DownloadManager *)sharedInstance;

@property (nonatomic, assign) int maxConcurrentCount;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic, assign) unsigned long long totalSpeedByte;

- (void)addDownloader:(BaseDownloader *)aDownloader;
- (void)removeDownloaderWithUid:(NSString *)aUid;

// 本地化存储，入数据库
- (void)saveAll;
- (void)loadAll;

- (void)readyAndGo;
@end
