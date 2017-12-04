//
//  BaseDownloader.m
//  TestDownload
//
//  Created by Lei Cai on 5/14/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "BaseDownloader.h"

@implementation BaseDownloader
- (id)init {
    self = [super init];
    if (self) {
        _state = DownloadStatusNA;
        _totalSizeByte = 0;
        _downloadedSizeByte = 0;
        _currentSpeedByte = 0;
        _progress = 0.0;
        _bAllowCellular = NO;
    }
    return self;
}

- (NSString *)uid {
    return nil;
}

- (NSString *)jsonContent {
    return nil;
}

- (void)setModel:(id)aModel {
    
}

- (void)start {
    
}

- (void)stop {
    
}

- (void)clear {
    
}

- (void)saveToDB {
    
}

- (void)loadFromDB {
    
}

#pragma mark - fetch size
- (void)queryTotalLengthWithBlock:(void(^)(unsigned long long totalSizeByte, NSError *error))aCompleteBlock {
    self.queryTotalLengthCompleteBlock = aCompleteBlock;
}

#pragma mark - util
+ (NSString *)sizeStringForBytes:(unsigned long long)aBytes {
    // 小于1KB
    if (aBytes < 1024) {
        return @"< 1K";
//        return [NSString stringWithFormat:@"%lldB", aBytes];
    }
    
    // 1KB - 1MB
    if ((aBytes >= 1024) && (aBytes < 1024*1024)) {
//        unsigned long long kb = aBytes / 1024ll;
//        return [NSString stringWithFormat:@"%lldK", kb];
        float kb = (float)aBytes / 1024.f;
        return [NSString stringWithFormat:@"%.2fK", kb];
    }
    
    // 1MB - 1GB
    if ((aBytes >= 1024*1024) && (aBytes < 1024*1024*1024)) {
        float mb = (float)aBytes / (1024.f*1024.f);
        return [NSString stringWithFormat:@"%.2fM", mb];
    }
    
    // 大于等于1GB
    if (aBytes >= 1024*1024*1024) {
        float gb = (float)aBytes / (1024.f*1024.f*1024.f);
        return [NSString stringWithFormat:@"%.2fG", gb];
    }
    
    return @"";
}

// return xx.xM or xx.xG
+ (NSString *)spaceSizeStringForBytes:(unsigned long long)aBytes {
    if (aBytes < 1024ull*1024*1024) {
        float mb = (float)aBytes / (1024.f*1024.f);
        if (mb < 0.1)
            return [NSString stringWithFormat:@"%.0fM", mb];
        else
            return [NSString stringWithFormat:@"%.1fM", mb];
    } else {
        float gb = (float)aBytes / (1024.f*1024.f*1024.f);
        return [NSString stringWithFormat:@"%.1fG", gb];
    }
}

+ (NSString *)downloadFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *appCachePath = [paths objectAtIndex:0];
    NSString *downloaderCachePath = [appCachePath stringByAppendingPathComponent:@"download"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:downloaderCachePath])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:downloaderCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return downloaderCachePath;
}

@end
