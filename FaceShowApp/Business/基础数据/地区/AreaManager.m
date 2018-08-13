//
//  AreaManager.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AreaManager.h"
#import <ASIHTTPRequest.h>

@implementation Area
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"areaID"}];
}
@end

@implementation AreaModel
@end

@interface AreaManager()
@property (nonatomic, strong) ASIHTTPRequest *areaRequest;
@end

@implementation AreaManager
+ (AreaManager *)sharedInstance {
    static dispatch_once_t once;
    static AreaManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[AreaManager alloc] init];
    });
    
    return sharedInstance;
}

- (AreaModel *)areaModel {
    if (!_areaModel) {
        NSString *localPath = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
        NSString *downloadPath = [self downloadedJsonPath];
        NSString *path = downloadPath? :localPath;
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        _areaModel = [[AreaModel alloc]initWithData:data error:nil];
    }
    return _areaModel;
}

- (void)updateWithLatestVersion:(NSString *)version url:(NSString *)url {
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"areadata_version"];
    if ([oldVersion isEqualToString:version]) {
        return;
    }
    [self.areaRequest clearDelegatesAndCancel];
    self.areaRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *appCachePath = [paths objectAtIndex:0];
    NSString *desPath = [appCachePath stringByAppendingPathComponent:@"arealist.json"];
    NSString *tmpPath = [appCachePath stringByAppendingPathComponent:@"arealist.tmp"];
    self.areaRequest.downloadDestinationPath = desPath;
    self.areaRequest.temporaryFileDownloadPath = tmpPath;
    self.areaRequest.allowResumeForFileDownloads = NO;
    WEAK_SELF
    [self.areaRequest setCompletionBlock:^{
        STRONG_SELF
        [[NSUserDefaults standardUserDefaults]setValue:version forKey:@"areadata_version"];
    }];
    [self.areaRequest startAsynchronous];
}

- (NSString *)downloadedJsonPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *appCachePath = [paths objectAtIndex:0];
    NSString *desPath = [appCachePath stringByAppendingPathComponent:@"arealist.json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:desPath]) {
        return desPath;
    }
    return nil;
}

@end
