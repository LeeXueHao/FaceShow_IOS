//
//  BaseDownloader.h
//  TestDownload
//
//  Created by Lei Cai on 5/14/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, DownloaderState) {
    DownloadStatusNA,
    DownloadStatusPrepare,
    DownloadStatusDownloading,
    DownloadStatusPaused,
    DownloadStatusFinished,
    DownloadStatusFailed = 99
};

@interface BaseDownloader : JSONModel
@property (nonatomic, assign) DownloaderState state;
@property (nonatomic, assign) unsigned long long totalSizeByte;
@property (nonatomic, assign) unsigned long long downloadedSizeByte;
@property (nonatomic, assign) unsigned long long currentSpeedByte;
@property (nonatomic, assign) float progress;

@property (nonatomic, assign) BOOL bAllowCellular;

/**
 *  以下方法需要子类集成
 */
- (NSString *)uid;
- (NSString *)jsonContent;

- (void)setModel:(id)aModel;
- (void)start;
- (void)stop;
- (void)clear;

- (void)saveToDB;
- (void)loadFromDB;
#pragma mark - fetch size
@property (nonatomic, copy) void(^queryTotalLengthCompleteBlock)(unsigned long long totalSizeByte, NSError *error);
- (void)queryTotalLengthWithBlock:(void(^)(unsigned long long totalSizeByte, NSError *error))aCompleteBlock;

#pragma mark - util
+ (NSString *)sizeStringForBytes:(unsigned long long)aBytes;
+ (NSString *)spaceSizeStringForBytes:(unsigned long long)aBytes;
+ (NSString *)downloadFolderPath;

@end
