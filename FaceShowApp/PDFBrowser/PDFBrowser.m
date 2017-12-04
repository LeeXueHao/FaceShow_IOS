//
//  PDFBrowser.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PDFBrowser.h"
#import "FileDownloadHelper.h"
#import "ResourceDisplayViewController.h"

@interface PDFBrowser ()
@property (nonatomic, strong) FileDownloadHelper *downloadHelper;
@end

@implementation PDFBrowser

- (void)browseFile {
    self.downloadHelper = [[FileDownloadHelper alloc] initWithURLString:self.urlString baseViewController:self.baseViewController];
    WEAK_SELF
    [self.downloadHelper startDownloadWithCompleteBlock:^(NSString *path) {
        STRONG_SELF
        [self openDoc:path];
    }];
}

- (void)openDoc:(NSString *)path{
    ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc] init];
    vc.urlString = path;
    vc.name = self.name;
    [[self.baseViewController nyx_visibleViewController].navigationController pushViewController:vc animated:YES];
}

@end
