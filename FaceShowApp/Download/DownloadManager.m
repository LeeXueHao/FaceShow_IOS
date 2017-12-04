//
//  DownloadManager.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/17/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloaderEntity.h"

#import "UrlDownloader.h"
@interface DownloadManager() {
    NSMutableArray *_disposableArray;
}

- (void)_updateObserver;
- (void)_checkToStart;
@end

@implementation DownloadManager
+ (DownloadManager *)sharedInstance {
    NSAssert([DownloadManager class] == self, @"Incorrect use of singleton : %@, %@", [DownloadManager class], [self class]);
    static dispatch_once_t once;
    static DownloadManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _maxConcurrentCount = 2;
        _queue = [NSMutableArray array];
        _totalSpeedByte = 0;
        _disposableArray = [NSMutableArray array];
    }
    return self;
}

- (void)addDownloader:(BaseDownloader *)aDownloader {
    for (BaseDownloader *d in self.queue) {
        if ([d.uid isEqual:aDownloader.uid]) {
            DDLogError(@"%@, already in download queue", aDownloader.uid);
            return;
        }
    }
    
    [self.queue addObject:aDownloader];
    [self _updateObserver];
}

- (void)removeDownloaderWithUid:(NSString *)aUid {
    for (BaseDownloader *d in self.queue) {
        if ([d.uid isEqual:aUid]) {
            [self.queue removeObject:d];
            [self _updateObserver];
            return;
        }
    }
    DDLogError(@"%@, not found in download queue", aUid);
}

// 本地化存储，入数据库
- (void)saveAll {
    for (BaseDownloader *d in self.queue) {
        [d saveToDB];
    }
}

- (void)loadAll {
    NSArray *items = [DownloaderEntity MR_findAll];
    for (DownloaderEntity *item in items) {
        NSError *error = nil;
        if ([item.type isEqualToString:@"UrlDownloader"]) {
            UrlDownloader *d = [[UrlDownloader alloc] initWithString:item.content error:&error];
            if (error) {
                DDLogError(@"db load downloader error");
                continue;
            }
            if (d.state == DownloadStatusDownloading) {
                d.state = DownloadStatusPrepare;
            }
            [[DownloadManager sharedInstance] addDownloader:d];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _checkToStart];
    });
}

- (void)readyAndGo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _checkToStart];
    });
}

#pragma mark - private API
- (void)_updateObserver {
    for (RACDisposable *d in _disposableArray) {
        [d dispose];
    }
    [_disposableArray removeAllObjects];
    
    for (BaseDownloader *d in self.queue) {
        @weakify(self);
        RACDisposable *d0 = [[d rac_valuesAndChangesForKeyPath:@"state"
                                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                      observer:self] subscribeNext:^(id x) {
            NSLog(@"change to : %@", x);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _checkToStart];
            });
        }];
        
        RACDisposable *d1 = [RACObserve(d, currentSpeedByte) subscribeNext:^(id x) {
            @strongify(self); if (!self) return;
            for (BaseDownloader *d in self.queue) {
                self.totalSpeedByte += d.currentSpeedByte;
            }
        }];
        
        [_disposableArray addObject:d0];
        [_disposableArray addObject:d1];
    }
}

/**
 *  此函数调用必须在同一线程(主线程)完成，避免ongoingCount读写冲突
 */
- (void)_checkToStart {
    int ongoingCount = 0;
    int prepareCount = 0;
    for(BaseDownloader *d in self.queue) {
        if (d.state == DownloadStatusDownloading) {
            ongoingCount++;
        }
        if (d.state == DownloadStatusPrepare) {
            prepareCount++;
        }
    }
    
    assert(ongoingCount <= self.maxConcurrentCount);
    while ((ongoingCount < self.maxConcurrentCount) && (prepareCount > 0)) {
        for(BaseDownloader *d in self.queue) {
            if (d.state == DownloadStatusPrepare) {
                [d start];
                ongoingCount++;
                prepareCount--;
                if (ongoingCount == self.maxConcurrentCount) {
                    break;
                }
            }
        }
    }
    
    
    DDLogDebug(@"download manager check to start");
}

@end
