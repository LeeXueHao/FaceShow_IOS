//
//  UrlDownloader.m
//  TestDownload
//
//  Created by Lei Cai on 5/14/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "UrlDownloader.h"
#import <RACExtScope.h>
#import <ASIHTTPRequest.h>
#import <NSString+Hashes.h>
#import "DownloaderEntity.h"
#import <objc/runtime.h>

@interface UrlDownloader()
@property (nonatomic, strong) ASIHTTPRequest<Ignore> *headerRequest;
@property (nonatomic, strong) ASIHTTPRequest<Ignore> *request;
// lastDate, lastSize 为计算下载速度
@property (nonatomic, strong) NSDate<Ignore> *lastDate;
@property (nonatomic, assign) unsigned long long lastSize;
@end

@implementation UrlDownloader

- (NSString *)uid {
    return [NSString stringWithFormat:@"%@-%@", [[self.url lastPathComponent] md5], [self.url md5]];
}

- (NSString *)jsonContent {
    return [self toJSONString];
}


- (void)setModel:(NSString *)aUrl {
    self.url = aUrl;
    self.state = DownloadStatusNA;
}

- (void)start {
    [self.request clearDelegatesAndCancel];
    self.request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    self.request.downloadDestinationPath = [self desFilePath];
    self.request.temporaryFileDownloadPath = [self tmpFilePath];
    self.request.allowResumeForFileDownloads = YES;
    
    __block unsigned long long received = 0;
    @weakify(self);
    [self.request setCompletionBlock:^{
        @strongify(self); if (!self) return;
        self.state = DownloadStatusFinished;
    }];
    
    [_request setFailedBlock:^{
        @strongify(self); if (!self) return;
        self.state = DownloadStatusFailed;
    }];
    
    [_request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        @strongify(self); if (!self) return;
        received += size;
        
        if (total == 0) {
            return;
        }
        
        float progress = (float)received / (float)total;
        
        if (ABS(total - self.totalSizeByte) > 100) {    // 使用更精确地
            self.totalSizeByte = total;
        }
        
        self.downloadedSizeByte = received;
        if (!self.lastDate) {
            self.lastDate = [NSDate date];
            self.lastSize = self.downloadedSizeByte;
        } else {
            NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:self.lastDate];
            if (t > 1) {
                float speed = (float)(self.downloadedSizeByte - self.lastSize) / t;
                self.currentSpeedByte = (unsigned long long)speed;
                self.lastSize = self.downloadedSizeByte;
                self.lastDate = [NSDate date];
            }
        }
        
        self.progress = progress;
    }];
    
    [self.request startAsynchronous];
    self.state = DownloadStatusDownloading;
}

- (void)stop {
    self.lastDate = nil;
    self.lastSize = self.downloadedSizeByte;
    
    [self.request clearDelegatesAndCancel];
    self.state = DownloadStatusPaused;
}

- (void)clear {
    [[NSFileManager defaultManager] removeItemAtPath:[self tmpFilePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self desFilePath] error:nil];
    self.lastSize = 0;
    self.downloadedSizeByte = 0;
}

- (void)saveToDB {
    @weakify(self);
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        @strongify(self); if (!self) return;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", self.uid];
        DownloaderEntity *item = [DownloaderEntity MR_findFirstWithPredicate:predicate];
        if (!item) {
            item = [DownloaderEntity MR_createEntityInContext:localContext];
        }
        item.uid = self.uid;
        item.content = self.jsonContent;
        item.type = [NSString stringWithCString:class_getName([self class]) encoding:NSUTF8StringEncoding];
    }];
}

- (void)loadFromDB {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", self.uid];
    DownloaderEntity *item = [DownloaderEntity MR_findFirstWithPredicate:predicate];
    NSError *error = nil;
    UrlDownloader *d = [[UrlDownloader alloc] initWithString:item.content error:&error];
    if (error) {
        DDLogError(@"db load downloader error");
    }
    
    NSMutableArray *aps = [[self class] allProperties];
    for (NSString *p in aps) {
        id value = [d valueForKey:p];
        [self setValue:value forKey:p];
    }
}

#pragma mark - fetch size
- (void)queryTotalLengthWithBlock:(void(^)(unsigned long long totalSizeByte, NSError *error))aCompleteBlock {
    [super queryTotalLengthWithBlock:aCompleteBlock];
    
    self.headerRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.url]];;
    @weakify(self);
    [self.headerRequest setHeadersReceivedBlock:^(NSDictionary *responseHeaders) {
        @strongify(self); if (!self) return;;
        [self.headerRequest clearDelegatesAndCancel];
        id size = [responseHeaders valueForKey:@"Content-Length"];
        if (self.totalSizeByte == 0) {
            if ([size isKindOfClass:[NSString class]]) {
                self.totalSizeByte = [size longLongValue];
            } else if ([size isKindOfClass:[NSNumber class]]) {
                self.totalSizeByte = [size unsignedLongLongValue];
            }
        }
        self.queryTotalLengthCompleteBlock(self.totalSizeByte, nil);
    }];
    
    [self.headerRequest setFailedBlock:^{
        @strongify(self); if (!self) return;;
        [self.headerRequest clearDelegatesAndCancel];
        self.queryTotalLengthCompleteBlock(0, self.headerRequest.error);
    }];
    
    [self.headerRequest startAsynchronous];
}

#pragma mark - subclass private api
- (NSString *)tmpFilePath {
    NSString *ret = [[[self class] downloadFolderPath] stringByAppendingPathComponent:[[self.url lastPathComponent] md5]];
    ret = [ret stringByAppendingString:@".tmp"];
    return ret;
}

- (NSString *)desFilePath {
    NSString *ret = [[[self class] downloadFolderPath] stringByAppendingPathComponent:[[self.url lastPathComponent] md5]];
    ret = [ret stringByAppendingString:@".pdf"];
    return ret;
}

#pragma mark - JSONModel
+ (BOOL)propertyIsIgnored:(NSString*)propertyName
{
    if ([propertyName isEqualToString: @"lastSize"]) return YES;
    return NO;
}

@end



@implementation NSObject (Properties)
+ (NSMutableArray *)allProperties
{
    NSMutableArray *theProps;
    
    if ([self superclass] != [NSObject class])
        theProps = [[self superclass] allProperties];
    else
        theProps = [NSMutableArray array];
    
    unsigned int outCount;
    objc_property_t *propList = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++)
    {
        objc_property_t * oneProp = propList + i;
        NSString *propName = [NSString stringWithUTF8String:property_getName(*oneProp)];
        [theProps addObject:propName];
    }
    free(propList);
    return theProps;
}
@end
