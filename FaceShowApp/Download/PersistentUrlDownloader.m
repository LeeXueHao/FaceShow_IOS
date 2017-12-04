//
//  PersistentUrlDownloader.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/20.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "PersistentUrlDownloader.h"

@implementation PersistentUrlDownloader

- (NSString *)tmpFilePath {
    NSString *ret = [[[self class] downloadFolderPath] stringByAppendingPathComponent:[self uid]];
    ret = [ret stringByAppendingString:@".tmp"];
    return ret;
}

- (NSString *)desFilePath {
    NSString *ret = [[[self class] downloadFolderPath] stringByAppendingPathComponent:[self uid]];
    ret = [ret stringByAppendingString:@".pdf"];
    return ret;
}

+ (NSString *)downloadFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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

+ (BOOL)fileExist:(NSString *)aUrl{
    UrlDownloader *tempDownloader = [[UrlDownloader alloc]init];
    [tempDownloader setModel:aUrl];
    NSString *uid = [tempDownloader uid];
    NSString *filePath = [[self downloadFolderPath]stringByAppendingPathComponent:uid];
    filePath = [filePath stringByAppendingString:@".pdf"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        return TRUE;
    }
    return FALSE;
}

+ (void)removeFile:(NSString *)aUrl{
    PersistentUrlDownloader *tempDownloader = [[PersistentUrlDownloader alloc]init];
    [tempDownloader setModel:aUrl];
    [tempDownloader clear];
}

+ (NSString *)localPathForUrl:(NSString *)aUrl{
    PersistentUrlDownloader *tempDownloader = [[PersistentUrlDownloader alloc]init];
    [tempDownloader setModel:aUrl];
    return [tempDownloader desFilePath];
}

@end
