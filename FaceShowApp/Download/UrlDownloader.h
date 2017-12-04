//
//  UrlDownloader.h
//  TestDownload
//
//  Created by Lei Cai on 5/14/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "BaseDownloader.h"

@interface UrlDownloader : BaseDownloader
@property (nonatomic, strong) NSString *url;
- (NSString *)desFilePath;
// the url string of the item to be downloaded
- (void)setModel:(NSString *)aUrl;
@end



@interface NSObject (Properties)
+ (NSMutableArray *)allProperties;
@end
